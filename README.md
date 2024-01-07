# AssemblyEncryptor
A small application for encrypting and decrypting a text message (x86 DOS tasm), the regularity of the encryption methods make it easier to decode, as it cyclical in nature, but it is still a fun exercise.

User interface:

Once started, the application prompts the user to enter a message and a key, then either ecnrypts it or decrypts it:

->in case the user presses (1) the message is put through the encryption methods 1 to 3 and displays the encrypted message

->in case the user presses (2) the message is put through the decryption methods 3 to 1 and displays the encrypted message

->a message in its initial form (that the user provided) cannot be decrypted futher

->a message cannot be encrypted more than three times as a loss of data is pesent otherwise


It uses three encryption methods:
=================================================================
 
 1. Adding the Nth char from the key to the corresponding Nth char from the message (in case the key is too short it starts from the beginning again and repeats until the needed length is met)
    Example:
Text:       T   h   i   s       i   s       m   y       m   e   s   s   a   g   e

ASCII:      84  104 105 115 32  105 115 32  109 121 32  109 101 115 115 97  103 101

Key:        k   e   y   k   e   y   k   e   y   k   e   y   k   e   y   k   e   y

ASCII:      107 101 121 107 101 121 107 101 121 107 101 121 107 101 121 107 101 121

Encrypted:  191 205 232 220 139 216 232 220 218 223 154 218 208 216 214 198 208 222

=================================================================

2. Adding a constant value to every character from the message
  Example:

Text:       T   h   i   s       i   s       m   y       m   e   s   s   a   g   e

ASCII:      84  104 105 115 32  105 115 32  109 121 32  109 101 115 115 97  103 101

Key:        k   e   y 

Key Size:   3   3   3   3   3   3   3   3   3   3   3   3   3   3   3   3   3   3

Encrypted:  87  107 108 118 35  108 118 35  112 124 35  112 104 118 118 100 108 124

=================================================================

3. For the third method we either add X, subtract X, or do nothing based on the value of the Nth key-character mod3
   ->case=1 adding X
   ->case=2 subtracting X
   ->case=3 we do nothing
   Where X is the value of the Nth key-character mod11
     Example:
   
Text:       T   h   i   s       i   s       m   y       m   e   s   s   a   g   e

ASCII:      84  104 105 115 32  105 115 32  109 121 32  109 101 115 115 97  103 101

Key:        k   e   y   k   e   y   k   e   y   k   e   y   k   e   y   k   e   y

ASCII:      107 101 121 107 101 121 107 101 121 107 101 121 107 101 121 107 101 121

X (mod 11): 5   4   2   5   4   2   5   4   2   5   4   2   5   4   2   5   4   2

Encrypted:  89  100 107 120 36  109 117 34  110 129 34  114 105 129 129 103 113 128

=================================================================
