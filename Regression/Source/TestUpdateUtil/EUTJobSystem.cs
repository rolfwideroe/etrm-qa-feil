﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using ElvizTestUtils;
using MessageHandler;
using NUnit.Framework;
using Shouldly;
using TestElvizUpdateTool.Helpers;
using static MessageHandler.Reporter;

namespace TestElvizUpdateTool
{
    [TestFixture]
    public class EUTJobSystem
    {
        public EUTJobSystem()
        {
            DestinationPath = @"\\BERSV-FS01\Felles\QA\Regression_EUT\PricesFromLocalFolder\";
            FullTestCaseFilePath = Path.Combine(Directory.GetCurrentDirectory() + Localfolderpath);
            ManageWindowsDirectories = new ManageWindowsDirectories(FullTestCaseFilePath, DestinationPath, true);
            ReportDateHandler = new ReportDateHandler(DateTime.Today.AddDays(-1));
            ReportDate = ReportDateHandler.IgnoreWeekends();
            IsDayLightTime = ReportDateHandler.IsDayLightTime();
        }

        string DestinationPath { get; }
        string FullTestCaseFilePath { get; }
        public bool IsDayLightTime { get; }
        static string TestcaseName { get; set; }
        static string Localfolderpath { get; set; }
        static EutJobs EutJobs { get; set; }
        static IEnumerable<JobItem> JobItemsList { get; set; }
        ManageWindowsDirectories ManageWindowsDirectories { get; }
        DateTime ReportDate { get; set; }
        ReportDateHandler ReportDateHandler { get; set; }


        static IEnumerable<string> EUTJobDescriptions = ConvertObjectToListOfString();


        [Test, TestCaseSource("EUTJobDescriptions")]
        public void DownloadAndCheckAreaPricesVizPrices(string description)
        {
            var execution = new Execution(description);
            execution.JobExecuted().ShouldBeTrue();

            var evaluation = new Evaluation(TestcaseName, description, ReportDate, IsDayLightTime);

            Display(evaluation.Result(), ShouldlyEvaluation.Empty);
        }

        [Test]
        public void TestLocalFolderJob()
        {
            ManageWindowsDirectories.Replenish();
            //Job id for Prices from local folder =35
            var jobid = JobAPI.GetJobsIdByDescription("Prices from local folder", "Historic Data Update Job");

            JobAPI.ExecuteAndAssertJob(jobid, 3600);
        }

        private static IEnumerable<string> ConvertObjectToListOfString()
        {
            Environment.CurrentDirectory = TestContext.CurrentContext.TestDirectory;
            TestcaseName = @"TestFiles\EUTJobs.xml";
            Localfolderpath = @"\TestFiles\TestsInLocalFolder";
            EutJobs = new EutJobs(TestcaseName);
            JobItemsList = EutJobs.TestCaseJobItemsList;

            return JobItemsList.Select(jobItem => jobItem.Description).ToList();
        }
    }
}
