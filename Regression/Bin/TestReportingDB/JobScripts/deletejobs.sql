
  declare @lastJobId int -- Max job id that will NOT be deleted
  set @lastJobId = 609 

  delete from StoredJobParameters where storedjobid not in ( select StoredJobId from scheduledjobs where ScheduledJobId <= @lastJobId)
  
  delete from ScheduledJobRuns where ScheduledJobId >@lastJobId

  delete from ScheduledJobTriggers where ScheduledJobId > @lastJobId

  delete from ScheduledJobs where ScheduledJobId > @lastJobId
  
  delete from StoredJobs where StoredJobId  not in ( select StoredJobId from scheduledjobs where ScheduledJobId <= @lastJobId)


