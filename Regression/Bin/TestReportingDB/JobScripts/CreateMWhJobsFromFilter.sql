declare @type VARCHAR(55)
declare @preFix VARCHAR(55) 

set @type='Volume in MWh'
set @preFix='MWh-'

  DECLARE @table table (
						JobIndex INT IDENTITY(1,1), 
						FilterName VARCHAR(50),
						ReportDate VARCHAR(50),
						FromDate VARCHAR(50),
						ToDate VARCHAR(50),
						ShortFromDate VARCHAR(50),
						ShortToDate VARCHAR(50),
						ShortFromDate2 VARCHAR(50),
						ShortToDate2 VARCHAR(50)
					  )
					  
  Insert into @table values ('El-Future-NordPool-EUR','20111101','20110101','20111231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-FixedPriceFloatingVolume-EUR','20111101','20110101','20121231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-AvgRateFuture-NASDAQ','20151125','20150101','20160101','20151025','20151026','20160327','20160328')
  Insert into @table values ('El-Forward-EUR','20111101','20100101','20121231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-ReserveCapacity-EUR','20111101','20110101','20111231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-Spot-EUR','20111101','20110101','20111231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-StructFlex-CapFloor-EUR','20111101','20110101','20111231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-StructFlex-Fixed-EUR','20111101','20100101','20161231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-StructFlex-Index-EUR','20111101','20100101','20161231','20111030','20111031','20120325','20120326')
  Insert into @table values ('El-StructFlex-Spot-EUR','20111101','20100101','20161231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-Forward-MW-EUR','20111101','20100101','20131231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-Forward-GJd-EUR','20111101','20100101','20131231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-Forward-MWhd-EUR','20111101','20100101','20131231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-Forward-Sm3d-EUR','20111101','20100101','20131231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-Forward-THD-GBP','20111101','20100101','20131231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-Future-ICE-TTF-EUR','20111101','20110101','20131231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-StructFlex-CapFloor-EUR','20111101','20110101','20111231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-Storage-TTF-Mix','20111101','20110101','20111231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-StructFlex-Fixed-GJd-EUR','20111101','20100101','20161231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-StructFlex-Fixed-MW-EUR','20111101','20100101','20161231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-StructFlex-Fixed-MWhd-EUR','20111101','20100101','20161231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-StructFlex-Fixed-Thd-GBP','20111101','20100101','20161231','20111030','20111031','20120325','20120326')
  Insert into @table values ('Gas-StructFlex-Index-Sm3d-EUR','20111101','20100101','20161231','20111030','20111031','20120325','20120326')


 --   Insert into @table values ('ElCert-Forward-OTC','20111101','20070101','20141231')
	--Insert into @table values ('Emission-Future-ICE-EUR','20111101','20100101','20121231')
	--Insert into @table values ('Emission-Future-NP-EUR','20111101','20100101','20121231')
	Insert into @table values ('Gas-FFF-ICEMonthAheadNBP-GBP','20111101','20100101','20121231','20111030','20111031','20120325','20120326')
	Insert into @table values ('Gas-Floating-Index-Mwhd-EUR','20111101','20100101','20141231','20111030','20111031','20120325','20120326')
--	Insert into @table values ('Oil-FFF-ICEBrentOilFLFSwap-USD','20111101','20100101','20121231')
	--Insert into @table values ('Oil-Future-ICE-USD','20111101','20100101','20121231')
	Insert into @table values ('El-Floating-Index-8020-EUR','20111101','20100101','20121231','20111030','20111031','20120325','20120326')




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
		declare @shortFromDate2 VARCHAR(55)
		declare @shortToDate2 VARCHAR(55)
		declare @reportDate VARCHAR(55)

		set @filterId=(SELECT FilterId FROM Filters WHERE FilterName=(SELECT FilterName FROM @table WHERE JobIndex=@index))

		set @useActualDateFX='False'
		set @fromDate=(SELECT FromDate FROM @table WHERE JobIndex=@index)
		set @toDate=(SELECT ToDate FROM @table WHERE JobIndex=@index)
		set @shortFromDate=(SELECT ShortFromDate FROM @table WHERE JobIndex=@index)
		set @shortToDate=(SELECT ShortToDate FROM @table WHERE JobIndex=@index)
		set @shortFromDate2=(SELECT ShortFromDate2 FROM @table WHERE JobIndex=@index)
		set @shortToDate2=(SELECT ShortToDate2 FROM @table WHERE JobIndex=@index)
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
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'NumberOfTimeSeries','5')

			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_0',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_0','Month')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_0',@jobName+'-Month')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_0','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_0',@fromDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_0','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_0','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_0',@toDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_0','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_0','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_0','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_0','True')

			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_1',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_1','Hour')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_1',@jobName+'-HourFall')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_1','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_1',@shortFromDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_1','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_1','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_1',@shortToDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_1','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_1','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_1','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_1','True')

			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_2',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_2','Hour')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_2',@jobName+'-HourSpring')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_2','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_2',@shortFromDate2)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_2','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_2','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_2',@shortToDate2)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_2','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_2','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_2','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_2','True')

			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_3',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_3','Min_15')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_3',@jobName+'-15MinFall')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_3','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_3',@shortFromDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_3','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_3','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_3',@shortToDate)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_3','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_3','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_3','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_3','True')

			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'TimeSeriesType_4',@type)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Resolution_4','Min_15')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'Alias_4',@jobName+'-15MinSpring')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeFromDate_4','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteFromDate_4',@shortFromDate2)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'FromDateOffset_4','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'IsRelativeToDate_4','False')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'AbsoluteToDate_4',@shortToDate2)
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'ToDateOffset_4','0')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeBase_4','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypePeak_4','True')
			INSERT INTO StoredJobParameters VALUES (@maxStoredJobId,'LoadTypeOffPeak_4','True')

		end
	set @index=@index+1
  end