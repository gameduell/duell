/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */
package com.gameduell.xsd;

import java.io.File;
import java.io.IOException;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.SAXException;

/**
 * @author jxav
 */
public class XsdValidator
{
    private final static String PROGRAM_NAME = XsdValidator.class.getSimpleName();

    private static String mXSDFileName;
    private static String mXMLFileName;

    public static void main(String[] args)
    {
        parseArgs(args);
        SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");

        File XSDFile = new File(mXSDFileName);
        File XMLFile = new File(mXMLFileName);

        try
        {
            Schema schema = factory.newSchema(XSDFile);
            Validator validator = schema.newValidator();

            Source source = new StreamSource(XMLFile);

            try
            {
                validator.validate(source);
            }
            catch (SAXException ex)
            {
                System.err.println(ex.getMessage());
                System.exit(1);
            }
            catch (IOException io)
            {
                System.err.println("Error reading XML source: " + mXMLFileName);
                System.err.println(io.getMessage());
                System.exit(3);
            }
        }
        catch (SAXException sch)
        {
            System.err.println("Error reading XML Schema: " + mXSDFileName);
            System.err.println(sch.getMessage());
            System.exit(3);
        }
    }

    /**
     * Checks and interprets the command line arguments.
     *
     * Code is based on Sun standard code for handling arguments.
     *
     * @param args An array of the command line arguments
     */
    private static void parseArgs(final String[] args)
    {
        int argNo = 0;

        while (argNo < args.length && args[argNo].startsWith("-"))
        {
            argNo++;
        }

        if ((argNo + 2) != args.length)
        {
            // Not given 2 files on input
            printUsageAndExit();
        }

        mXSDFileName = args[argNo];
        mXMLFileName = args[++argNo];
    }

    /**
     * Outputs usage message to standard error.
     */
    public static void printUsageAndExit()
    {
        System.err.println("Usage: " + PROGRAM_NAME + " XSDFILE XMLFILE");
        System.exit(2);
    }
}