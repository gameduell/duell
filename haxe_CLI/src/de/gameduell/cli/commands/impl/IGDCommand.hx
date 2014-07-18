package de.gameduell.cli.commands.impl;
/**
 * @autor kgar
 * @date 30.06.2014.
 * @company Gameduell GmbH
 */
interface IGDCommand {
    function execute( cmdStr:String ):String;
}
