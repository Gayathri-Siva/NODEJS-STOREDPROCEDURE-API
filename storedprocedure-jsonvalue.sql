



-- ALTER PROCEDURE [AddEditUser]

declare @JsonData nvarchar(MAX) = N'{"id":1,
"UserCode":"is70898",
"UserFName":"bindhu",
"UserDesignation":"project lead",
"UserEmailID ":"bindhu@integra.co.in",
"PhoneNo ":"9098909890",
"PersonalEmailID":"bindhu2integra.co.in",
"UpdatedBy":1,
"isActive" :1,
"Password" :"2020202020",
"UserLName ":"nisha",
"isInternalUser" :1,
"OrgID":111,
"OrgDivID" :234,
"RoleID":[
			{"id":1,
			"isActive":"1"},

			{"id":2,
			"isActive":"1"}
],
"RoleIdLength":2,
"SubRoleID":[
			{"id":1,
			"isHavingRights":"1"},

			{"id":2,
			"isHavingRights":"1"}
],
"SubRoleIdLength":2,
"AtyID":[
			{"id":3,
			"isActive":"1"},

			{"id":4,
			"isActive":"1"},

			{"id":5,
			"isActive":"1"}
],
"AtyIDLength":3,
"CustID":[
			{"id":1,
			"isActive":"1"},

			{"id":2,
			"isActive":"1"}
],
"CustIDLength":2,
"ReportingID":[
			{"id":8,
			"isActive":"1"},

			{"id":4,
			"isActive":"1"}
],
"ReportingIDLength":2,

}'
,
@UpdaterID int = 2
-- as
begin

declare
        @id INT =0,
       @UserCode VARCHAR(50) = JSON_VALUE(@JsonData,'$.UserCode'),
	   @UserFName  NVARCHAR(150) = JSON_VALUE(@JsonData,'$.UserFName'),
	   @UserDesignation NVARCHAR(500) = JSON_VALUE(@JsonData,'$.UserDesignation'),
	   @UserEmailID NVARCHAR(150) = JSON_VALUE(@JsonData,'$.UserEmailID'),
	   @PhoneNo  VARCHAR(15) = JSON_VALUE(@JsonData,'$.PhoneNo '),
	   @PersonalEmailID NVARCHAR(150) = JSON_VALUE(@JsonData,'$.PersonalEmailID'),
	   @UpdatedBy INT = JSON_VALUE(@JsonData,'$.UpdatedBy'),
	   @isActive BIT = JSON_VALUE(@JsonData,'$.isActive'),
	   @Password  NVARCHAR(50) = JSON_VALUE(@JsonData,'$.Password'),
	   @UserLName NVARCHAR(150) = JSON_VALUE(@JsonData,'$.UserLName'),
	   @isInternalUser BIT = JSON_VALUE(@JsonData,'$.isInternalUser'),
	   @OrgID INT = JSON_VALUE(@JsonData,'$.OrgID'),
	   @OrgDivID INT = JSON_VALUE(@JsonData,'$.OrgDivID'),
	   @RoleIdLength INT = JSON_VALUE(@JsonData,'$.RoleIdLength'),
	   @SubRoleIdLength INT = JSON_VALUE(@JsonData,'$.SubRoleIdLength'),
	   @AtyIDLength INT = JSON_VALUE(@JsonData,'$.AtyIDLength'),
	   @CustIDLength INT = JSON_VALUE(@JsonData,'$.CustIDLength'),
	   @ReportingIDLength INT = JSON_VALUE(@JsonData,'$.ReportingIDLength')


		-- @id              INT=0, 
		--@UserCode        VARCHAR(50), 
		--@UserFName       NVARCHAR(150), 
		--@UserDesignation NVARCHAR(500) = NULL, 
		--@UserEmailID     NVARCHAR(150)=NULL, 
		--@PhoneNo         VARCHAR(15)=NULL, 
		--@PersonalEmailID NVARCHAR(150)=NULL, 
		--@UpdatedBy       INT, 
		--@isActive        BIT, 
		--@Password        NVARCHAR(50)=NULL, 
		--@UserLName       NVARCHAR(150)=NULL, 
		--@isInternalUser  BIT, 
		--@OrgID           INT, 
		--@OrgDivID        INT  

      IF EXISTS(SELECT 1 
                FROM   [mst_user_dtl] 
                WHERE  usercode = @UserCode and OrgID=@OrgID and OrgDivID=@OrgDivID) 
        BEGIN 
		set @id = (SELECT UserID 
					FROM   [mst_user_dtl] 
					WHERE  usercode = @UserCode and OrgID=@OrgID and OrgDivID=@OrgDivID)
            UPDATE [mst_user_dtl] 
            SET    [usercode] = @UserCode, 
                   [userfname] = @UserFName, 
                   [userdesignation] = @UserDesignation, 
                   [useremailid] = @UserEmailID, 
                   [phoneno] = @PhoneNo, 
                   [personalemailid] = @PersonalEmailID, 
                   [updatedby] = @UpdatedBy, 
                   [updateddate] = Getdate(), 
                   [isactive] = @isActive, 
                   --[password] = @Password, 
                   [userlname] = @UserLName, 
                   [isinternaluser] = @isInternalUser, 
                   [orgid] = @OrgID, 
                   [orgdivid] = @OrgDivID 
            WHERE  userid = @id 
        END 
      ELSE 
        BEGIN 
            INSERT INTO [mst_user_dtl] 
                        ([usercode], 
                         [userfname], 
                         [userdesignation], 
                         [useremailid], 
                         [phoneno], 
                         [personalemailid], 
                         [updatedby], 
                         [updateddate], 
                         [isactive], 
                         [password], 
                         [userlname], 
                         [isinternaluser], 
                         [orgid], 
                         [orgdivid]) 
            VALUES      (@UserCode, 
                         @UserFName, 
                         @UserDesignation, 
                         @UserEmailID, 
                         @PhoneNo, 
                         @PersonalEmailID, 
                         @UpdatedBy, 
                         Getdate(), 
                         @isActive, 
                         @Password, 
                         @UserLName, 
                         @isInternalUser, 
                         @OrgID, 
                         @OrgDivID) 
			set @id=SCOPE_IDENTITY();
        END



------BEGIN AddEditUserRoleAccess stored procedure -------
		Declare @rolecount int =0;
while(@rolecount<@RoleIdLength)
begin
	select distinct 
	JSON_Value(@JsonData,'$.RoleID['+Convert(int,@rolecount)+'].id') as roleid,
	--JSON_Value(@JsonData,'$.RoleId['+Convert(int,@rolecount)+'].UpdaterID') as updaterId,
	JSON_Value(@JsonData,'$.RoleID['+Convert(int,@rolecount)+'].isActive') as isactiveroll

	into #Roll
	FROM  
	OPENJSON( @JsonData) 
	set @rolecount = @rolecount+1

	declare 
	         @RoleID int,
			-- @UpdaterID int,
	         @isActiveRoll bit
	 
	Select	
	        @RoleID = roleid,
	        @UpdaterID = @UpdaterID,
			@isActiveRoll = isactiveroll
			from #Roll

		EXEC	[dbo].[AddEditUserRoleAccess]
		@UserID = @id,
		@RoleID = @RoleID ,
		@UpdaterID = @UpdaterID,
		@isActive = @isActiveRoll

	drop table #Roll
end
------END AddEditUserRoleAccess stored procedure -------



------BEGIN AddEditSubRole stored procedure -------
Declare @subrolecount int =0;
while(@subrolecount<@SubRoleIdLength)
begin
	select distinct 
	JSON_Value(@JsonData,'$.SubRoleID['+Convert(int,@subrolecount)+'].id') as subroleid,
	--JSON_Value(@JsonData,'$.RoleId['+Convert(int,@rolecount)+'].UpdaterID') as updaterId,
	JSON_Value(@JsonData,'$.SubRoleID['+Convert(int,@subrolecount)+'].isHavingRights') as ishavingrights

	into #SubRoll
	FROM  
	OPENJSON( @JsonData) 
	set @subrolecount = @subrolecount+1

	declare 
	         @SubRoleID int,
			-- @UpdaterID int,
	         @isHavingRights bit
	 
	Select	
	        @SubRoleID = subroleid,
	        @UpdaterID = @UpdaterID,
			@isHavingRights = ishavingrights
			from #SubRoll

	EXEC  [dbo].[AddEditSubRole]
		@UpdaterID = @UpdaterID,
		@UserID = @id,
		@SubRoleID = @SubRoleID,
		@isHavingRights = @isHavingRights

	drop table #SubRoll
end
------END AddEditSubRole stored procedure -------




-------BEGIN AddEditActivityRights STORED PROCEDURE ------------
Declare @activityrightscount int =0;
while(@activityrightscount<@AtyIDLength)
begin
	select distinct 
	JSON_Value(@JsonData,'$.AtyID['+Convert(int,@activityrightscount)+'].id') as activityrightsid,
	--JSON_Value(@JsonData,'$.RoleId['+Convert(int,@rolecount)+'].UpdaterID') as updaterId,
	JSON_Value(@JsonData,'$.AtyID['+Convert(int,@activityrightscount)+'].isActive') as isactive

	into #ActivityRights
	FROM  
	OPENJSON( @JsonData) 
	set @activityrightscount = @activityrightscount+1

	declare 
	         @AtyID int,
			-- @UpdaterID int,
	         @isActiveRights bit
	 
	Select	
	        @AtyID = activityrightsid,
	        @UpdaterID = @UpdaterID,
			@isActiveRights = isactive
			from #ActivityRights

	EXEC [dbo].[AddEditActivityRights]
		@UserID = @id,
		@AtyID =  @AtyID,
		@isActive = @isActiveRights,
		@UpdaterID = @UpdaterID 

	drop table #ActivityRights
end
------END AddEditActivityRights stored procedure -------




----------BEGIN AddEditCustomer STORED PROCEDURE-------------
Declare @customeridcount int =0;
while(@customeridcount<@CustIDLength)
begin
	select distinct 
	JSON_Value(@JsonData,'$.CustID['+Convert(int,@customeridcount)+'].id') as customerid,
	--JSON_Value(@JsonData,'$.RoleId['+Convert(int,@rolecount)+'].UpdaterID') as updaterId,
	JSON_Value(@JsonData,'$.CustID['+Convert(int,@customeridcount)+'].isActive') as isactive

	into #Customer
	FROM  
	OPENJSON( @JsonData) 
	set @customeridcount = @customeridcount+1

	declare 
	         @CustID int,
			-- @UpdaterID int,
	         @isActiveCustomer bit
	 
	Select	
	        @CustID = customerid,
	        @UpdaterID = @UpdaterID,
			@isActiveCustomer = isactive
			from #Customer

	EXEC   [dbo].[AddEditCustomer]
		@UserID = @id,
		@CustID = @CustID,
		@isActive = @isActiveCustomer,
		@UpdaterId = @UpdaterID

	drop table #Customer
end
----------END AddEditCustomer STORED PROCEDURE---------------





----------BEGIN AddEditReporting STORED PROCEDURE-------------
Declare @reportidcount int =0;
while(@reportidcount<@ReportingIDLength)
begin
	select distinct 
	JSON_Value(@JsonData,'$.ReportingID['+Convert(int,@customeridcount)+'].id') as reportid,
	--JSON_Value(@JsonData,'$.RoleId['+Convert(int,@rolecount)+'].UpdaterID') as updaterId,
	JSON_Value(@JsonData,'$.ReportingID['+Convert(int,@customeridcount)+'].isActive') as isactive

	into #Reporting
	FROM  
	OPENJSON( @JsonData) 
	set @reportidcount = @reportidcount+1

	declare 
	         @ReportingID int,
			-- @UpdaterID int,
	         @isActiveReporting bit
	 
	Select	
	        @ReportingID = reportid,
	        @UpdaterID = @UpdaterID,
			@isActiveReporting = isactive
			from #Reporting

		EXEC [dbo].[AddEditReporting]
		@UserID = @id,
		@ReportingID = @ReportingID,
		@isActive = @isActiveReporting,
		@UpdaterID = @UpdaterID

	drop table #Reporting
end
----------END AddEditReporting STORED PROCEDURE---------------




END 