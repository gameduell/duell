#!/bin/sh

javac com/gameduell/xsd/XsdValidator.java
jar cfe ../bin/schema_validator.jar com.gameduell.xsd.XsdValidator com/gameduell/xsd/XsdValidator.class
rm com/gameduell/xsd/XsdValidator.class
