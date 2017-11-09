
  
  declare @type VARCHAR(55)
declare @preFix VARCHAR(55) 

set @type='Contract price'
set @preFix='ContractPrice-'

  DECLARE @table table (
						JobIndex INT IDENTITY(1,1), 
						FilterName VARCHAR(50),
						ReportDate VARCHAR(50),
						FromDate VARCHAR(50),
						ToDate VARCHAR(50),
						ShortFromDate VARCHAR(50),
						ShortToDate VARCHAR(50)
					  )
					  
  Insert into @table values ('El-Future-NordPool-EUR','20111101','20110101','20111231','20110101','20111231')
  Insert into @table values ('El-FixedPriceFloatingVolume-EUR','20111101','20100101','20141231','20110101','20111231')
  Insert into @table values ('El-AvgRateFuture-NASDAQ','20151125','20150101','20160101','20150101','20160101')
  Insert into @table values ('El-Forward-EUR','20111101','20100101','20121231','20110101','20111231')
  Insert into @table values ('El-ReserveCapacity-EUR','20111101','20110101','20111231','20110101','20111231')
  Insert into @table values ('El-Spot-EUR','20111101','20110101','20111231','20110101','20111231')
  Insert into @table values ('El-StructFlex-CapFloor-EUR','20111101','20110101','20111231','20110101','20111231')
  Insert into @table values ('El-StructFlex-Fixed-EUR','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('El-StructFlex-Index-EUR','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('El-StructFlex-Spot-EUR','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('Gas-Forward-MW-EUR','20111101','20100101','20131231','20110101','20111231')
  Insert into @table values ('Gas-Forward-GJd-EUR','20111101','20100101','20131231','20110101','20111231')
  Insert into @table values ('Gas-Forward-MWhd-EUR','20111101','20100101','20131231','20110101','20111231')
  Insert into @table values ('Gas-Forward-Sm3d-EUR','20111101','20100101','20131231','20110101','20111231')
  Insert into @table values ('Gas-Forward-THD-GBP','20111101','20100101','20131231','20110101','20111231')
  Insert into @table values ('Gas-Future-ICE-TTF-EUR','20111101','20110101','20131231','20110101','20111231')
  Insert into @table values ('Gas-StructFlex-CapFloor-EUR','20111101','20110101','20111231','20110101','20111231')
  Insert into @table values ('Gas-Storage-TTF-Mix','20111101','20110101','20111231','20110101','20111231')
  Insert into @table values ('Gas-StructFlex-Fixed-GJd-EUR','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('Gas-StructFlex-Fixed-GJh-EUR','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('Gas-StructFlex-Fixed-MW-EUR','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('Gas-StructFlex-Fixed-MWhd-EUR','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('Gas-StructFlex-Fixed-Thd-GBP','20111101','20100101','20161231','20110101','20111231')
  Insert into @table values ('Gas-StructFlex-Index-Sm3d-EUR','20111101','20100101','20161231','20110101','20111231')


    Insert into @table values ('ElCert-Forward-OTC','20111101','20070101','20141231','20070101','20141231')
	Insert into @table values ('Emission-Future-ICE-EUR','20111101','20100101','20121231','20100101','20121231')
	Insert into @table values ('Emission-Future-NP-EUR','20111101','20100101','20121231','20100101','20121231')
	Insert into @table values ('Gas-FFF-ICEMonthAheadNBP-GBP','20111101','20100101','20121231','20110101','20111231')
	Insert into @table values ('Gas-Floating-Index-Mwhd-EUR','20111101','20100101','20141231','20110101','20111231')
	Insert into @table values ('Oil-FFF-ICEBrentOilFLFSwap-USD','20111101','20100101','20121231','20100101','20121231')
	Insert into @table values ('Oil-Future-ICE-USD','20111101','20100101','20121231','20100101','20131231')
	Insert into @table values ('El-Floating-Index-8020-EUR','20111101','20100101','20121231','20110101','20111231')

	Insert into @table values ('Currency-AvgRateForward','20111101','20100101','20121231','20100101','20121231')
	Insert into @table values ('Currency-Forward','20111101','20100101','20121231','20100101','20121231')
	Insert into @table values ('Currency-Future','20111101','20100101','20121231','20100101','20121231')
	Insert into @table values ('GreenCert-Forward-OTC-WithPricebasis','20111101','20070101','20141231','20070101','20141231')
	Insert into @table values ('Special-Cases-ZeroVolume','20111101','20100101','20121231','20120101','20121231')
	Insert into @table values ('Special-Cases-GridPointPricebasis','20111101','20100101','20121231','20110101','20111231')
	

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
		declare @shortFromDate VARCHAR(55)
		declare @shortToDate VARCHAR(55)
		declare @reportDate VARCHAR(55)



		set @filterId=(SELECT FilterId FROM Filters WHERE FilterName=(SELECT FilterName FROM @table WHERE JobIndex=@index))

		set @useActualDateFX='False'
		set @fromDate=(SELECT FromDate FROM @table WHERE JobIndex=@index)
		set @toDate=(SELECT ToDate FROM @table WHERE JobIndex=@index)
		set @shortFromDate=(SELECT ShortFromDate FROM @table WHERE JobIndex=@index)
		set @shortToDate=(SELECT ShortToDate FROM @table WHERE JobIndex=@index)
		set @reportDate=(SELECT ReportDate FROM @table WHERE JobIndex=@index)


		DECLARE @jobName varchar(55)
		set @jobName=@preFix+(SELECT FilterName FROM @table WHERE JobIndex=@index)

		if not exists (select * from StoredJobs WHERE [Description]=@jobName)
		begin

			INSERT INTO StoredJobs VALUES('Reporting Db Calculated Values Export',@jobName)

			declare @maxStoredJobId INT
			set @maxStoredJobId=(Select max(StoredJobId) from StoredJobs)

			INSERT INTO ScheduledJobs VALUES (@maxStoredJobId,'Vizard',GETDATE(),'Vizard',GETDATE(),0,NULL)

			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Name',@jobName)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FilterId',@filterId)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeReportDate','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteReportDate',@reportDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Intraday','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'UseActualDateSpotRate',@useActualDateFX)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'NumberOfTimeSeries','3')


			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_0',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_0','Month')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_0',@jobName+'-Month')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_0','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_0',@fromDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_0','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_0','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_0',@toDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_0','0')


			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_1',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_1','Hour')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_1',@jobName+'-Hour')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_1','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_1',@shortFromDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_1','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_1','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_1',@shortToDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_1','0')
	

			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_2',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_2','Min_15')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_2',@jobName+'-15Min')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_2','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_2',@shortFromDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_2','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_2','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_2',@shortToDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_2','0')


		end
	set @index=@index+1
  end