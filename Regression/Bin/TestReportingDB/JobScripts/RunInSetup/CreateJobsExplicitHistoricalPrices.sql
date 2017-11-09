
  
  DECLARE @table table (
						JobIndex INT IDENTITY(1,1), 
						FilterName VARCHAR(50),
						JobPreFix VARCHAR(50),
						ReportDate VARCHAR(50),
						FromDate VARCHAR(50),
						ToDate VARCHAR(50),
						JobType VARCHAR(50)
					  )
					  
  Insert into @table values ('ExpHistoricalPrices-Spot-EUR','MWh-','20111101','20100101','20141231','Volume in MWh')
  Insert into @table values ('ExpHistoricalPrices-Spot-EUR','MW-','20111101','20100101','20141231','Volume in MW')
  Insert into @table values ('ExpHistoricalPrices-Spot-EUR','Volume-','20111101','20100101','20141231','Volume')
  Insert into @table values ('ExpHistoricalPrices-Spot-EUR','AccruedPL-','20111101','20100101','20141231','PL accrued')
  Insert into @table values ('ExpHistoricalPrices-Spot-EUR','ContractPrice-','20111101','20100101','20141231','Contract price')
  Insert into @table values ('ExpHistoricalPrices-Spot-EUR','ContractValue-','20111101','20100101','20141231','Contract value')
  Insert into @table values ('ExpHistoricalPrices-Spot-EUR','AccruedCF-','20111101','20100101','20141231','CF accrued')
    
  Insert into @table values ('ExpHistoricalPrices-FSD-EUR','MWh-','20111101','20100101','20141231','Volume in MWh')
  Insert into @table values ('ExpHistoricalPrices-FSD-EUR','MW-','20111101','20100101','20141231','Volume in MW')
  Insert into @table values ('ExpHistoricalPrices-FSD-EUR','Volume-','20111101','20100101','20141231','Volume')
  Insert into @table values ('ExpHistoricalPrices-FSD-EUR','AccruedPL-','20111101','20100101','20141231','PL accrued')
  Insert into @table values ('ExpHistoricalPrices-FSD-EUR','ContractPrice-','20111101','20100101','20141231','Contract price')
  Insert into @table values ('ExpHistoricalPrices-FSD-EUR','ContractValue-','20111101','20100101','20141231','Contract value')
  Insert into @table values ('ExpHistoricalPrices-FSD-EUR','AccruedCF-','20111101','20100101','20141231','CF accrued')

  select * from @table
  
  declare @index int
  set @index=1
  declare @maxIndex int
  set @maxIndex=(select MAX(JobIndex) from @table)
  
  while @index<=@maxIndex
		  begin

		declare @wsId INT




		declare @filterId VARCHAR(55)
		declare @granularity VARCHAR(55)
		declare @useActualDateFX VARCHAR(55)
		declare @fromDate VARCHAR(55)
		declare @toDate VARCHAR(55)
		declare @reportDate VARCHAR(55)
		declare @jobType VARCHAR(55)





		set @filterId=(SELECT FilterId FROM Filters WHERE FilterName=(SELECT FilterName FROM @table WHERE JobIndex=@index))

		set @useActualDateFX='False'
		set @fromDate=(SELECT FromDate FROM @table WHERE JobIndex=@index)
		set @toDate=(SELECT ToDate FROM @table WHERE JobIndex=@index)
		set @jobType=(SELECT JobType FROM @table WHERE JobIndex=@index)

		set @reportDate=(SELECT ReportDate FROM @table WHERE JobIndex=@index)


		DECLARE @jobName varchar(255)
		set @jobName=(SELECT JobPreFix+FilterName FROM @table WHERE JobIndex=@index)

		if not exists (select * from StoredJobs WHERE [Description]=@jobName)
		begin

		INSERT INTO StoredJobs VALUES('Reporting Db Calculated Values Export',@jobName)

		declare @maxStoredJobId INT
		set @maxStoredJobId=(Select max(StoredJobId) from StoredJobs)

		INSERT INTO ScheduledJobs VALUES (@maxStoredJobId,'Vizard',GETDATE(),'Vizard',GETDATE(),0,NULL, NULL)

		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Name',@jobName)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FilterId',@filterId)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeReportDate','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteReportDate',@reportDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Intraday','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'UseActualDateSpotRate',@useActualDateFX)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IntrinsicEvalutationOfCapacity','True')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'UseVolatilitySurface','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'UseLiveCurrencyRates','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'NumberOfTimeSeries','4')


		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_0',@jobType)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_0','Month')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_0',@jobName+'-Month')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_0','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_0',@fromDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_0','0')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_0','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_0',@toDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_0','0')
		
		if  @jobType='Volume in MWh' or @jobType='Volume' or @jobType='Volume in MW'
		begin 
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_0','True')
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_0','True')
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_0','True')
		end

		
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_1',@jobType)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_1','Hour')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_1',@jobName+'-Hour')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_1','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_1',@fromDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_1','0')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_1','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_1',@toDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_1','0')


		if  @jobType='Volume in MWh' or @jobType='Volume' or @jobType='Volume in MW'
		begin 
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_1','True')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_1','True')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_1','True')
		end


		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_2',@jobType)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_2','Min_15')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_2',@jobName+'-15Min')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_2','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_2',@fromDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_2','0')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_2','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_2',@toDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_2','0')


		if  @jobType='Volume in MWh' or @jobType='Volume' or @jobType='Volume in MW'
		begin 
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_2','True')
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_2','True')
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_2','True')
		end

		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_3',@jobType)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_3','Min_30')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_3',@jobName+'-30Min')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_3','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_3',@fromDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_3','0')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_3','False')
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_3',@toDate)
		INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_3','0')


		if  @jobType='Volume in MWh' or @jobType='Volume' or @jobType='Volume in MW'
		begin 
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_3','True')
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_3','True')
				INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_3','True')
		end
	end

	set @index=@index+1
  end