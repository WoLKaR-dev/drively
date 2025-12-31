using Nefarius.ViGEm.Client;
using Nefarius.ViGEm.Client.Targets.Xbox360;
using System;
using System.Net;
using System.Net.Sockets;
using System.Net.NetworkInformation;

// 1. ViGEm
var client = new ViGEmClient();
var xbox = client.CreateXbox360Controller();
xbox.Connect();

// 2. UDP
int port = 55556;
UdpClient udp = new UdpClient(port);
IPEndPoint remoteEP = new IPEndPoint(IPAddress.Any, 0);

// 3. Mostrar IPs del PC
Console.WriteLine("Escuchando UDP en:");
foreach (var ni in NetworkInterface.GetAllNetworkInterfaces())
{
    foreach (var ua in ni.GetIPProperties().UnicastAddresses)
    {
        if (ua.Address.AddressFamily == AddressFamily.InterNetwork &&
            !IPAddress.IsLoopback(ua.Address))
        {
            Console.WriteLine($"  IP: {ua.Address}  Puerto: {port}");
        }
    }
}

Console.WriteLine("Esperando datos...\n");

// 4. Loop principal
while (true)
{
    byte[] data = udp.Receive(ref remoteEP);

    if (data.Length >= 3)
    {
        double brake = Math.Round(((data[0] * 10.0) / 255.0), 2); // 0–100
        double gas = Math.Round(((data[1] * 10.0) / 255.0), 2);  // 0–100
        double steering = Math.Round((((data[2] / 255.0) * 20.0) - 10.0), 2); // -10–10
        

        short steeringVal = (short)(steering * 3276);

        xbox.SetAxisValue(Xbox360Axis.LeftThumbX, steeringVal);
        xbox.SetSliderValue(Xbox360Slider.LeftTrigger, (byte)(brake * 25));
        xbox.SetSliderValue(Xbox360Slider.RightTrigger, (byte)(gas * 25));
        xbox.SubmitReport();
    }
}
