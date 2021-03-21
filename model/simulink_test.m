function simulink_test

import matlab.unittest.TestRunner
import matlab.unittest.TestSuite
import matlab.unittest.plugins.XMLPlugin
import matlab.unittest.plugins.codecoverage.CoberturaFormat
import sltest.plugins.ModelCoveragePlugin
import sltest.plugins.coverage.CoverageMetrics
import sltest.plugins.coverage.ModelCoverageReport

try
    % Configure test environment
    project = openProject('Model.prj');
    tests = TestSuite.fromFolder('component', 'IncludingSubfolders', true);
    runner = TestRunner.withNoPlugins;
    mkdir('report')
    
    % Plugin configuration
    rptfile = 'report/coverage.xml';
    rpt = CoberturaFormat(rptfile);
    coverage_metrics = CoverageMetrics('Decision',true);
    model_coverage = ModelCoveragePlugin('Collecting', coverage_metrics, 'Producing', rpt);
    junit_export = XMLPlugin.producingJUnitFormat('report/junit.xml');
    
    runner.addPlugin(model_coverage);
    runner.addPlugin(junit_export);

    % Execute tests
    result = runner.run(tests);

    % Print results
    table(result)
catch e
    disp(e.getReport);
    if ~usejava('desktop')
       exit(1);
    end
end
if ~usejava('desktop')
   exit force;
end
