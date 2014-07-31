/**
 * @autor kgar
 * @date 30.06.2014.
 * @company Gameduell GmbH
 */

package duell.commands;
interface IGDCommand {
    function execute(cmdStr : String , args : Array<String>):String;
}
