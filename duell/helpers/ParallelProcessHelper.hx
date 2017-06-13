package duell.helpers;

import haxe.Constraints.Function;

import python.Tuple;
import python.multiprocessing.Process;

import duell.objects.DuellProcess;
import duell.helpers.PlatformHelper;
import duell.helpers.LogHelper;

using StringTools;

typedef ParallelJob = {
    @:optional var group:Int;
    var job:Function;
    @:optional var name:String;
    @:optional var args:Array<Dynamic>;
}

class ParallelProcessHelper {

    private var processList:Array<Process>;

    public function new() {}

    public function run( jobs:Array<ParallelJob> ):Void {
        if( jobs == null ) return;

        var numberKernels = getLogicalKernels();
        processList       = new Array<Process>();
        LogHelper.info('', 'Running jobs on $numberKernels Kernels ... ');
        for( i in 0...jobs.length ) {
            var job  = jobs[ i ];
            var args = Reflect.hasField( job, 'args' ) ? new Tuple( job.args ) : null;
            var p    = new Process( Reflect.field( job, 'group' ),
                                   job.job, 
                                   Reflect.field( job, 'name'),
                                   args);
            processList.push( p );
            p.start();

            if( numberKernels == processList.length || i == jobs.length-1 ) {
                for ( proc in processList ) proc.join();

                processList = [];
            }
        }
    }

    private function getLogicalKernels():Int {
        var numberKernelsString = "";
        var numberKernels = 0;

        if (PlatformHelper.hostPlatform == Platform.WINDOWS){
            var dp        = new DuellProcess("", "wmlc", ["cpu", "get", "NumberOfLogicalProcessors"], {block:true, systemCommand:true, errorMessage: "grabbing number of kernels"});
            var dpOutput  = dp.getCompleteStdout().toString();
            var rows      = dpOutput.split("\n");
            numberKernelsString = rows.length > 1 ? rows[1].trim() : "";
        } else {
            var dp              = new DuellProcess("", "sysctl", ["-n", "hw.logicalcpu_max"], {block:true, systemCommand:true, errorMessage: "grabbing number of kernels"});
            numberKernelsString = dp.getCompleteStdout().toString();
        }

        try {
            numberKernels = Std.parseInt( numberKernelsString );
        } catch( e:Dynamic ) {
           LogHelper.warn("Error grabbing number of kernels! " + e);
        }

        return numberKernels != 0 && numberKernels != null ? numberKernels : 1;
    }
}