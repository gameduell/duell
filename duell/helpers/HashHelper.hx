/**
 * @autor rcam
 * @date 29.04.2015.
 * @company Gameduell GmbH
 */

package duell.helpers;

class HashHelper
{
    static public function getFnv32IntFromIntArray(array: Array<Int>): Int
    {
        var hash:Int = 0;

        for (val in array)
        {
            hash *= 16777619;
            hash ^= val;
        }

        return hash;
    }

    static public function getFnv32IntFromString(string: String): Int
    {
        var hash:Int = 0;

        for (i in 0...string.length)
        {
            hash *= 16777619;
            hash ^= string.charCodeAt(i);
        }

        return hash;
    }
}
