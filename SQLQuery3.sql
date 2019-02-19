
alter PROCEDURE [AddEditUser] 
		 @id              INT=0, 
		@UserCode        VARCHAR(50), 
		@UserFName       NVARCHAR(150), 
		@UserDesignation NVARCHAR(500) = NULL, 
		@UserEmailID     NVARCHAR(150)=NULL, 
		@PhoneNo         VARCHAR(15)=NULL, 
		@PersonalEmailID NVARCHAR(150)=NULL, 
		@UpdatedBy       INT, 
		@isActive        BIT, 
		@Password        NVARCHAR(50)=NULL, 
		@UserLName       NVARCHAR(150)=NULL, 
		@isInternalUser  BIT, 
		@OrgID           INT, 
		@OrgDivID        INT 
AS 
  BEGIN 

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
		
		EXEC [dbo].[AddEditActivityRights]
		@UserID = @id,
		@AtyID = 1,
		@isActive = 1,
		@UpdaterID = 1 



		EXEC  [dbo].[AddEditSubRole]
		@UpdaterID = 1,
		@UserID = @id,
		@SubRoleID = 2,
		@isHavingRights = 1

		EXEC	[dbo].[AddEditUserRoleAccess]
		@UserID = @id,
		@RoleID = 1,
		@UpdaterID = 1,
		@isActive = 1

		EXEC   [dbo].[AddEditCustomer]
		@UserID = @id,
		@CustID = 1,
		@isActive = 1,
		@UpdaterId = 2

		EXEC [dbo].[AddEditReporting]
		@UserID = @id,
		@ReportingID = 1,
		@isActive = 1,
		@UpdaterID = 1



END 