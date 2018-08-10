// release dollar sign for other libraries possible
jQuery.noConflict();
// all docusign front end logic starts from document.loaded event
jQuery(document).ready(function($) {

/*------------------------------ Init ------------------------------*/
	
	loadAdminTab();

/*------------------------- Helper functions -----------------------*/
	
	function loadAdminTab() {
		hideAll();
		showMessages(dsGlobal.responseJson.messages);
		if (dsGlobal.responseJson.action === 'ShowDemo') {
			window.location.href = 'docusignsetupdemo?demo=1';
		} else if (dsGlobal.responseJson.action === 'ShowLogin') {
			$('#accountTabContent').show();
			$('#login-or-create-trial').show();
			if (dsGlobal.responseJson.admin.account.docusignAccounts.length > 1) {
				$.each(dsGlobal.responseJson.admin.account.docusignAccounts, function(key, value) {   
				     $('#selectedAccountId').append($("<option></option>").attr("value",value).text(value)); 
				});
				$('#accountDropdownField').show();
			}
			if ($('#docusignEnvironment').val() === 'other') {
				$('#otherEnvironmentField').show();
			}
		} else if (dsGlobal.responseJson.action === 'ShowConnect') {
			$('#accountTabContent').show();
			$('#login-to-connect').show();
			if (dsGlobal.isMetadataApiSupported === false) {
				$('#trusted-network-salesforce').show();
			}
		} else if (dsGlobal.responseJson.action === 'ShowTrialForm') {
			$('#accountTabContent').show();
			$('#trial-step-two').show();
		} else if (dsGlobal.responseJson.action === 'ShowHome') {
			if (dsGlobal.responseJson.admin.adminUser !== true) {
				$('#settingsTabListItem').hide();
				$('#accountTabListItem').hide();
				$('#layoutsTabListItem').hide();
				$('#customTagsTabListItem').hide();
				$('#usersTabListItem').hide();
			}
			$('#homeTab').addClass('active');
			$('#navigation').show();
			$('#homeTabContent').show();
		} else if (dsGlobal.responseJson.action === 'ShowUsers') {
			$('#usersTab').addClass('active');
			$('#navigation').show();
			$('#usersTabContent').show();
		} else if (dsGlobal.responseJson.action === 'ShowSettings') {
			$('#settingsTab').addClass('active');
			$('#navigation').show();
			populateSettings();
			$('#settingsTabContent').show();
		} else if (dsGlobal.responseJson.action === 'ShowAccount') {
			$('#accountTab').addClass('active');
			$('#navigation').show();
			$('#accountTabContent').show();
			$('#account-installed-content').show();
		} else if (dsGlobal.responseJson.action === 'ShowCustomTags') {
			$('#customTagsTab').addClass('active');
			$('#navigation').show();
			//populateCustomTags();
			$('#customTagTabContent').show();
		}  else if (dsGlobal.responseJson.action === 'ShowLayouts') {
			$('#layoutsTab').addClass('active');
			$('#navigation').show();
			$('#layoutsTabContent').show();
			if (dsGlobal.responseJson.admin.metadataRemoteSiteNeeded) {
				$('#layoutsMetadataContent').show();
				$('#layoutsMetadataButtons').show();
			} else {
				for (var i = 0; i < dsGlobal.responseJson.admin.layouts.length; i++) {
					$("#desktopCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', dsGlobal.responseJson.admin.layouts[i].desktopSelected === true);
					$("#mobileCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', dsGlobal.responseJson.admin.layouts[i].mobileSelected === true);
					$("#statusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', dsGlobal.responseJson.admin.layouts[i].statusListSelected === true);
					$("#recipientStatusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', dsGlobal.responseJson.admin.layouts[i].recipientStatusListSelected === true);
					
					if(dsGlobal.responseJson.admin.layouts[i].showVerifyWithDnB){
						$("#verifyWithDnb").prop('checked', true);
					}
				}
				$('#layoutsDropdownContent').show();
				$('#layoutsDnbContent').show();
				$('#layoutsChecklistContent').show();
				$('#layoutsButtons').show();
			}
		}
		if(!Modernizr.svg) {
		    console.log('SVG is NOT supported.');
		    // Browser doesnt support SVG (eg. IE 8).  Replace all SVG with PNG.
		    $('.logo').attr('src', dsGlobal.docusignPNG);
		    $('#searchButton').css("background-image", "url("+dsGlobal.searchIconPNG+")");
		    $('.docusignlogo').attr('src', dsGlobal.DocuSignLoadingLogoPNG);
		    $('#languageSettingsCloseIcon').attr('src', dsGlobal.deleteIconPNG);
		}		
	}
	
	function hideAll() {
		$('#navigation').hide();
		$('#homeTab').removeClass('active');
		$('#usersTab').removeClass('active');
		$('#settingsTab').removeClass('active');
		$('#accountTab').removeClass('active');
		$('#layoutsTab').removeClass('active');
		$('#customTagsTab').removeClass('active');
		$('#homeTabContent').hide();
		$('#customTagsTabContent').hide();
		$('#settingsTabContent').hide();
		$('#accountTabContent').hide();
		$('#accountDropdownField').hide();
		$('#otherEnvironmentField').hide();
		$('#login-or-create-trial').hide();
		$('#login-to-connect').hide();
		$('#trial-step-two').hide();
		$('#account-installed-content').hide();
		$('#layoutsTabContent').hide();
		$('#layoutsMetadataContent').hide();
		$('#layoutsMetadataButtons').hide();
		$('#layoutsDropdownContent').hide();
		$('#layoutsDnbContent').hide();
		$('#layoutsChecklistContent').hide();
		$('#layoutsButtons').hide();
		$('#usersTabContent').hide();
		$('#trusted-network-salesforce').hide();
		$('#add-buttons-to-layouts').hide();
		hideLoading();
	}
	
	$("#searchInput").keyup(function(event){
		if (event.keyCode == 13) {
			search();
		}
	});
	
	$("#newCustomTag").click(function(event){
		$('#newCustomTagInfo').show();
		$('#newCustomTagFormat').show();
		$('#newCustomTagToolTip').show();
		$('#newCustomTagValidation').show();
		$('#newCustomTagInputLimit').show();
		$('#newCustomTagAdvanced').show();
		$('#newCustomTagSaveCancel').show();
		$('#customTagTabContent').hide();
	});
	
	$(".ip-range-button").click(function(event){
		$(this).addClass("active");
	});
	
	$("#searchButton").click(function(){
		search();
	});
	
	function search() {
		if ($("#searchInput").val()) {
			window.open('https://www.docusign.com/results#type=default&startIndex=0&qu=' + escape($("#searchInput").val()));
		}
	}
	
	$("#loginButton").click(function(){
		showLoading();
		dsGlobal.responseJson.admin.account.docusignEmail = $("#docusignLoginEmail").val();
		dsGlobal.responseJson.admin.account.docusignPassword = $("#docusignPassword").val();
		dsGlobal.responseJson.admin.account.docusignEnvironment = $("#docusignEnvironment").val();
		dsGlobal.responseJson.admin.account.otherDocusignEnvironment = $("#otherDocusignEnvironment").val();
		dsGlobal.responseJson.admin.account.selectedAccountId = $("#selectedAccountId").val();
		try {
            Visualforce.remoting.Manager.invokeAction(
                dsGlobal.login, dsGlobal.responseJson.admin.account,
                function(result, event) {
                    remoteActionHandler(result, event);
                }
            );
        } catch (err) {
            console.log(err);
        }
    });
    
    $(".forgot-password").click(function(){
    	var env = "www";
    	if ($('#docusignEnvironment').val() === 'production') {
    		var dataCenter = window.location.host.toString().split('.')[1];
    		if(dataCenter.startsWith('eu')){
    			env = 'eu';
    		} else {
    			env = "www";
    		}
    	} else if ($('#docusignEnvironment').val() === 'demo') {
    		env = "demo";
    	} else if ($('#otherDocusignEnvironment').val() === 'stage') {
    		env = "wwwstage";
    	} else if ($('#otherDocusignEnvironment').val() === 'test') {
    		env = "test";
    	} else if ($('#otherDocusignEnvironment').val() === 'test1') {
    		env = "test1";
    	} else if ($('#otherDocusignEnvironment').val() === 'test2') {
    		env = "test2";
    	} 
    	$(".forgot-password").attr("href", "https://" + env + ".docusign.net/Member/MemberForgotPassword.aspx");
    });
    
    $("#createAccountButton").click(function(){
    	if ($("#trialAgreeCheckbox").is(':checked') && $("#docusignTrialEmail").val().indexOf('@')>0 && 
    		$("#docusignTrialEmail").val().lastIndexOf('.')>2)
    	{
	    	showLoading();
			try {
	            Visualforce.remoting.Manager.invokeAction(
	                dsGlobal.prepareTrialAccount, $("#docusignTrialEmail").val(),
	                function(result, event) {
	                    remoteActionHandler(result, event);
	                    if (result.admin.trial) {
		        			$("#fullName").val(result.admin.trial.fullName);
		        			$("#phoneNumber").val(result.admin.trial.phoneNumber);
		        			$("#companyName").val(result.admin.trial.companyName);
		        			$("#country").val(result.admin.trial.country);
		        			$("#streetAddress").val(result.admin.trial.streetAddress);
		        			$("#city").val(result.admin.trial.city);
		        			$("#stateProvince").val(result.admin.trial.stateProvince);
		        			$("#postalCode").val(result.admin.trial.postalCode);
							$.each(result.admin.trial.countries, function(key, value) {
								if (result.admin.trial.country === value) {
							    	$('#country').append($("<option selected></option>").attr("value",value).text(value));
								} else {
							    	$('#country').append($("<option></option>").attr("value",value).text(value));
							    }
							});
							toggleStateFields();
							$.each(result.admin.trial.states, function(key, value) {
								if (result.admin.trial.stateProvince === value) {
							    	$('#usState').append($("<option selected></option>").attr("value",value).text(value));
								} else {
							    	$('#usState').append($("<option></option>").attr("value",value).text(value));
							    }
							});
						}
	                }
	            );
	        } catch (err) {
	            console.log(err);
	        }
        }
    });
    
    $('#country').change(function(){
    	toggleStateFields();
    });
    
    function toggleStateFields() {
    	if ($('#country').val() === 'United States') {
    		$('#stateProvince').hide();
    		$('#usState').show();
    	} else {
    		$('#usState').hide();
    		$('#stateProvince').show();
    	} 
    }
    
    $("#trialFormNextButton").click(function(){
		showLoading();
		try {
			var state = $("#stateProvince").val();
			if ($("#country").val() === 'United States') {
				state = $("#usState").val();
			}
            Visualforce.remoting.Manager.invokeAction(
                dsGlobal.createTrialAccount, {docusignTrialEmail:$("#docusignTrialEmail").val(),
                	fullName:$("#fullName").val(),phoneNumber:$("#phoneNumber").val(),
                	companyName:$("#companyName").val(),country:$("#country").val(),
                	streetAddress:$("#streetAddress").val(),city:$("#city").val(),
                	stateProvince:state,postalCode:$("#postalCode").val()},
                function(result, event) {
                    remoteActionHandler(result, event);
                    $("#docusignLoginEmail").val(result.admin.account.docusignEmail);
                    $("#docusignPassword").focus();
                }
            );
        } catch (err) {
            console.log(err);
        }
    });
	
	$("#connectButton").click(function(){
		if ($("#connectAgreeCheckbox").is(':checked')) {
			showLoading();
			createRemoteSite('');
        }
    });
    
    $("#addRemoteSiteButton").click(function(){
		showLoading();
		createRemoteSite('?t=l');
    });
	
	$("#updateLayoutsButton").click(function(){
 		showLoading();
 		for (var i = 0; i < dsGlobal.responseJson.admin.layouts.length; i++) {
 			dsGlobal.responseJson.admin.layouts[i].desktopSelected = $("#desktopCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked');
 			dsGlobal.responseJson.admin.layouts[i].showVerifyWithDnB = $("#verifyWithDnb").prop('checked');
			if (dsGlobal.responseJson.admin.layouts[i].showMobileCheckbox === true) {
				dsGlobal.responseJson.admin.layouts[i].mobileSelected = $("#mobileCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked');
			}
 			dsGlobal.responseJson.admin.layouts[i].statusListSelected = $("#statusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked');
			if (dsGlobal.responseJson.admin.layouts[i].showRecipientStatusCheckbox === true) {
				dsGlobal.responseJson.admin.layouts[i].recipientStatusListSelected = $("#recipientStatusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked');
			}
 		}
		try {
            Visualforce.remoting.Manager.invokeAction(
                dsGlobal.updateLayouts, dsGlobal.responseJson.admin.layouts,
                function(result, event) {
                    remoteActionHandler(result, event);
                }
            );
        } catch (err) {
            console.log(err);
        }
    });
	
	$("#modifyAccountConfigButton").click(function(){
		dsGlobal.responseJson.action = 'ShowLogin';
		loadAdminTab();
    });
	
	$("#trialFormBackButton, #cancelButton").click(function(){
		dsGlobal.responseJson.messages = [];
		dsGlobal.responseJson.action = 'ShowLogin';
		loadAdminTab();
    });
	
	$("#docusignTab").click(function(){
		if ($("#docusignTab").attr('href')) {
			showLoading();
			try {
	            Visualforce.remoting.Manager.invokeAction(
	                dsGlobal.findDocuSignUrl,
	                function(result, event) {
                		dsGlobal.responseJson.messages = result.messages;
	                	if (result.url) {
	                    	var newWin = window.open(unescapeHtmlSpecialCharacters(result.url));
							if (!newWin || newWin.closed || typeof newWin.closed=='undefined') {
								dsGlobal.responseJson.messages[0] =
									{code:'UnknownError',description:dsGlobal.windowBlockedByBrowserText,severity:'Error'};
							}
	                    }
        				loadAdminTab();
	                }
	            );
	        } catch (err) {
	            console.log(err);
	        }
        }
    });
    
    /*
     * This function un-escapes all html special characters.
     * @param str the string to be modified
     */
    function unescapeHtmlSpecialCharacters(str) {
        if (!str) {
            return '';
        }
        return str.replace(/&quot;/g,'"').replace(/&amp;/g,"&").replace(/&lt;/g,"<").replace(/&gt;/g,">");
    }
    
	function showLoading() {
		$('.fullscreenload').show();
		$("#cancelLayoutsButton").removeAttr("href");
		$("#updateLayoutsButton").removeAttr("href");
		$("#loginButton").removeAttr("href");
		$("#connectButton").removeAttr("href");
		$("#createAccountButton").removeAttr("href");
	}
	
	function hideLoading() {
		$('.fullscreenload').hide();
		$("#cancelLayoutsButton").attr("href", "?t=h");
		$("#updateLayoutsButton").attr("href", "javascript:void(0);");
		$("#loginButton").attr("href", "#");
		$("#connectButton").attr("href", "#");
		$("#createAccountButton").attr("href", "#");
	}
	
	$("#connectAgreeCheckbox").click(function() {
		if ($("#connectAgreeCheckbox").is(':checked')) {
			$("#connectButton").removeClass("inactive");
		} else {
			$("#connectButton").addClass("inactive");
		}
	});
	
	$("#docusignTrialEmail").keyup(function() {
		toggleCreateAccountButton();
	});
	
	$("#fullName, #companyName").keyup(function() {
		$('#dsAlert').hide();
	});
	
	$("#trialAgreeCheckbox").click(function() {
		toggleCreateAccountButton();
	});
	
	function toggleCreateAccountButton() {
		if ($("#trialAgreeCheckbox").is(':checked') && $("#docusignTrialEmail").val().indexOf('@')>0 && $("#docusignTrialEmail").val().lastIndexOf('.')>2) {
			$("#createAccountButtonDiv").removeClass("inactive");
		} else {
			$("#createAccountButtonDiv").addClass("inactive");
		}
	}
	
	function createRemoteSite(redirectUrl) {
	    // Calls the Metdata API from JavaScript to create the Remote Site Setting to permit Apex callouts
	    var request =
	        '<?xml version="1.0" encoding="utf-8"?>' +
	        '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
	            '<env:Header>' +
	                '<urn:SessionHeader xmlns:urn="http://soap.sforce.com/2006/04/metadata">' +
	                    '<urn:sessionId>' + dsGlobal.sessionId + '</urn:sessionId>' +
	                '</urn:SessionHeader>' +
	            '</env:Header>' +
	            '<env:Body>' +
	                '<createMetadata xmlns="http://soap.sforce.com/2006/04/metadata">' +
	                    '<metadata xsi:type="RemoteSiteSetting">' +
	                        '<fullName>DocuSignDlrsMdapi</fullName>' +
	                        '<description>Metadata API Remote Site Setting for Declarative Rollup Tool (DLRS). Create by DocuSign for Salesforce package.</description>' +
	                        '<disableProtocolSecurity>false</disableProtocolSecurity>' +
	                        '<isActive>true</isActive>' +
	                        '<url>https://'+ dsGlobal.responseJson.admin.host +'</url>' +
	                    '</metadata>' +
	                '</createMetadata>' +
	            '</env:Body>' +
	        '</env:Envelope>';
	    $.ajax({
            type: "POST",
            url: 'https://' + dsGlobal.responseJson.admin.host + '/services/Soap/m/31.0',
            processData: false,
            contentType: "text/xml",
            headers: {SOAPAction: "''"},
            dataType: "xml",
            data: request,
            success: 
            	function(anythng, status, xhr) { 
            		handleRemoteSiteResult(true, redirectUrl); 
            	},
            error: 
            	function(xhr, status, errorThr) { 
            		handleRemoteSiteResult(false, redirectUrl);
            	}
        });
	}
	
	function handleRemoteSiteResult(success, redirectUrl) {
		if (redirectUrl) {
			if (success) {
				window.location.href = redirectUrl;
			} else {
				hideAll();
				$('#layoutsTab').addClass('active');
				$('#navigation').show();
				$('#layoutsTabContent').show();
				$('#add-buttons-to-layouts').show();
				showMessages([{
					severity : 'Error',
					code:'MetadataApiError', 
					description:dsGlobal.noSupportMetadataAPIText
				}]);
			}
		} else {
			dsGlobal.responseJson.admin.account.salesforceUsername = $("#salesforceUsername").val();
			dsGlobal.responseJson.admin.account.salesforcePassword = $("#salesforcePassword").val();
			dsGlobal.responseJson.admin.account.salesforceEnvironment = $("#salesforceEnvironment").val();
			dsGlobal.responseJson.admin.account.useMetadataApi = dsGlobal.isMetadataApiSupported;
			try {
	            Visualforce.remoting.Manager.invokeAction(
	                dsGlobal.connect, dsGlobal.responseJson.admin.account,
	                function(result, event) {
	                    remoteActionHandler(result, event);
	                }
	            );
	        } catch (err) {
	            console.log(err);
	        }
		}
	}
	
	$('#desktopHeader').click(function() {
		selectAllDesktop();
	});
	
	$('#mobileHeader').click(function() {
		selectAllMobile();
	});
	
	$('#statusListHeader').click(function() {
		selectAllStatusList();
	});
	
	$('#recipientStatusListHeader').click(function() {
		selectAllRecipientStatusList();
	});
	
	$('#layoutDropdown').change(function() {
		clearAll();
		if ($('#layoutDropdown').val() === 'All') {
			selectAllDesktop();
			selectAllMobile();
			selectAllStatusList();
			selectAllRecipientStatusList();
		} else if ($('#layoutDropdown').val() === 'Desktop') {
			selectAllDesktop();
		} else if ($('#layoutDropdown').val() === 'Mobile') {
			selectAllMobile();
		}
	});
	
	$('#docusignEnvironment').change(function() {
		if ($('#docusignEnvironment').val() === 'other') {
			$('#otherEnvironmentField').show();
		} else {
			$('#otherEnvironmentField').hide();
		}
	});
	
	function selectAllDesktop() {
		var checked = !$("#desktopCheckbox" + dsGlobal.responseJson.admin.layouts[0].uniqueId).prop('checked');
		for (var i = 0; i < dsGlobal.responseJson.admin.layouts.length; i++) {
			$("#desktopCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', checked);
		}
	}
	
	function selectAllMobile() {
		var checked = !$("#mobileCheckbox" + dsGlobal.responseJson.admin.layouts[0].uniqueId).prop('checked');
		for (var i = 0; i < dsGlobal.responseJson.admin.layouts.length; i++) {
			if (dsGlobal.responseJson.admin.layouts[i].showMobileCheckbox === true) {
				$("#mobileCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', checked);
			}
		}
	}
	
	function selectAllStatusList() {
		var checked = !$("#statusCheckbox" + dsGlobal.responseJson.admin.layouts[0].uniqueId).prop('checked');
		for (var i = 0; i < dsGlobal.responseJson.admin.layouts.length; i++) {
			$("#statusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', checked);
		}
	}
	
	function selectAllRecipientStatusList() {
		var checked = !$("#recipientStatusCheckbox" + dsGlobal.responseJson.admin.layouts[0].uniqueId).prop('checked');
		for (var i = 0; i < dsGlobal.responseJson.admin.layouts.length; i++) {
			if (dsGlobal.responseJson.admin.layouts[i].showRecipientStatusCheckbox === true) {
				$("#recipientStatusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', checked);
			}
		}
	}
	
	function clearAll() {
		for (var i = 0; i < dsGlobal.responseJson.admin.layouts.length; i++) {
			$("#desktopCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', false);
			$("#mobileCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', false);
			$("#statusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', false);
			$("#recipientStatusCheckbox" + dsGlobal.responseJson.admin.layouts[i].uniqueId).prop('checked', false);
		}
	}
	
	/**
     * This function handles the result from Salesforce Remote Action call.
     * @param result the result of the Salesforce Remote Action call
     * @param event the event of the Salesforce Remote Action call
     */
    function remoteActionHandler(result, event) {
        console.log('remoteActionHandler called');
        if (event.status && result) {
			if ((result.isMetadataApiSupported === true) || (result.isMetadataApiSupported === false)) {
				dsGlobal.isMetadataApiSupported = result.isMetadataApiSupported;
			}
			if (result.action) {
        		dsGlobal.responseJson.action = result.action;
        	}
        	if (result.messages) {
        		dsGlobal.responseJson.messages = result.messages;
        	}
        	if (result.admin) {
        		if (result.admin.adminUser === true) {
	        		dsGlobal.responseJson.admin.adminUser = true;
        		}
	        	if (result.admin.account && result.admin.account.docusignAccounts) {
		        	dsGlobal.responseJson.admin.account.docusignAccounts = result.admin.account.docusignAccounts;
	        	}
        	}
        }
        loadAdminTab();
    }
    
    function showMessage(errorCode, errorDescription) {
    	errorDescription = errorDescription.replace('layoutsLink', '<a href="?t=l">' + dsGlobal.layoutsText + '</a>');
		errorDescription = errorDescription.replace('usersLink', '<a href="?t=u">' + dsGlobal.usersText + '</a>');
		errorDescription = errorDescription.replace('userSettingsLink', '<a target="_blank" href="/setup/personalInformationSetup.apexp">' + dsGlobal.clickHereText + '</a>');
        $('#dsAlert ul').append('<li><p>'+errorDescription+'</p></li>');
        $('#dsAlert').show();
    }

    function showMessages(messages) {
        $('#dsAlert').hide();
        $('#dsAlert ul').empty();
		$('.alert-messages').removeClass('info');
		$('.alert-messages').removeClass('successful');
        for (var m = 0; m < messages.length; m++) {
        	$('#dsAlert').show();
        	if (messages[m].severity === 'Success') {
        		$('.alert-messages').addClass('successful');
        	} else if (messages[m].severity === 'Info') {
        		$('.alert-messages').addClass('info');
        	}
            showMessage(messages[m].code, messages[m].description);
        }
        if (messages.length > 0) {
        	$("html, body").animate({ scrollTop: 0 }, "fast");
        }
    }
    
    function populateCustomTags() {
        var settings = dsGlobal.responseJson.admin.customTags;
    }
    


    // Populate the envelope settings
    function populateSettings() {
    	console.log('populateSettings called.');
        var settings = dsGlobal.responseJson.admin.settings;
        console.log(settings);
    	// Email Settings
    	populateCheckbox('disableUserEmailSubjectCheckBox', settings.disableEmailSubjectEditing);
    	populateCheckbox('disableUserEmailMessageCheckBox', settings.disableEmailMessageEditing);        
    	populateEmailSettings(settings.docuSignLocalizationSettings);
		populateEmailChatterSettings(settings.chatterTextDto);
    	// Rcipient Role Settings
    	$('#recipientRoleSettingsTextarea').val(settings.recipientRoleNames);

    	// Send Settings
    	populateCheckbox('hideSendNowButton', settings.hideSendNowButton);
    	populateCheckbox('hideNextButton', settings.hideNextButton);
    	populateCheckbox('enableSFCalloutLimit', settings.enableSFCalloutLimit);
    	populateCheckbox('enableMobileTaggingUI', settings.enableMobileAppForSF1);
    	populateCheckbox('displayTaggerPageInNewWindow', settings.displayTaggerPageInNewWindow);
    	populateCheckbox('displayInPersonSigningPageInNewWindow', settings.displayInPersonSigningPageInNewWindow);
		populateCheckbox('reminderSettingsCheckbox', settings.enableRemindAndExpirationSettings);
		if(settings.enableRemindAndExpirationSettings === true) {
			$('#reminderSettings').show();
			$('#remindSignersTextInput').val(populateRemindExpireSettings(settings.reminderDays));
			$('#continueToSendRemindersTextInput').val(populateRemindExpireSettings(settings.reminderRepeat));
			$('#expireRequestInTextInput').val(populateRemindExpireSettings(settings.expireDays));
			$('#warnSignersTextInput').val(populateRemindExpireSettings(settings.expireWarning));
		} else {
			$('#reminderSettings').hide();
		}
		populateCheckbox('hideRemindAndExpireSettings', settings.hideRemindAndExpirationSettings);
    	// Chatter Settings
    	$('#dsChatterDropdown').val(settings.chatterSettingCode);
    	if(settings.chatterSettingCode === 'Disabled') {
    		$('#chatter-settings').hide();
    		$('#dsChatterLanguageDropdown').hide();
    	} else {
    		$('#chatter-settings').show();
    		$('#dsChatterLanguageDropdown').show();
    	}
    	populateChatterEventSettings(settings, dsGlobal.chatterLanguageCodeText);
    }

    // Populate the email settings
    function populateEmailSettings(localizationSettings) {
    	console.log('populateEmailSettings called.');
    	console.log(localizationSettings);
    	if(!localizationSettings)
    		return;
    	$('.email-settings .email-setting').remove();
		for(var i = 0; i < localizationSettings.length; i++) {
            addEmailSetting(localizationSettings[i]);
		}
		checkLocalizationSettingsList();
    }
    
    // populcate the email chatter settings
    function populateEmailChatterSettings(localizationSettings) {
    	if(!localizationSettings)
    		return;
    	var html = '';
    	html += '<select class="small" id="dsChatterLanguageDropdownSelect">';
    	for(var i = 0; i < localizationSettings.length; i++) {
    		var languageCode = localizationSettings[i].LanguageCode;
    		var language = '';
    		if (dsGlobal.chatterLanguageCodeText === languageCode) {
    			language = localizationSettings[i].Language;
    		} else {
    			language = formatLanguage(localizationSettings[i].Language);
    		}
            html += '<option value="' + languageCode + '">' + language + '</option>';
		}
		html += '</select>';
		$('#dsChatterLanguageDropdown').html(html);
    }

    // Helper function for populating checkbox value
    function populateCheckbox(id, enabled) {
    	if(enabled === true) {
    		$('#'+id).prop('checked', true);
    	} else {
    		$('#'+id).prop('checked', false);
    	}
    }

    // Helper function for populating chatter event setting
    function populateChatterEventSettings(settings, selectedLanguageCode) {
    	var chatterSettings = settings.chatterTextDto; 
    	for(var i = 0; i < chatterSettings.length; i++) {
    		var chatterText = chatterSettings[i];
    		if (chatterText.LanguageCode === selectedLanguageCode) {
    			// checkbox
    			$('#chatterEnvelopeSentCheckbox').prop('checked', settings.envelopeSentChatterEnabled);
    			$('#chatterEnvelopeDeliveredCheckbox').prop('checked', settings.envelopeDeliveredChatterEnabled);
    			$('#chatterEnvelopeCompletedCheckbox').prop('checked', settings.envelopeCompletedChatterEnabled);
    			$('#chatterEnvelopeDeclinedCheckbox').prop('checked', settings.envelopeDeclinedChatterEnabled);
    			$('#chatterEnvelopeVoidedCheckbox').prop('checked', settings.envelopeVoidedChatterEnabled);
    			$('#chatterRecipientSentCheckbox').prop('checked', settings.recipientSentChatterEnabled);
    			$('#chatterRecipientDeliveredCheckbox').prop('checked', settings.recipientDeliveredChatterEnabled);
    			$('#chatterRecipientCompletedCheckbox').prop('checked', settings.chatterRecipientCompleted);
    			$('#chatterRecipientSignedCheckbox').prop('checked', settings.recipientSignedChatterEnabled);
    			$('#chatterRecipientDeclinedCheckbox').prop('checked', settings.recipientDeclinedChatterEnabled);
    			$('#chatterActionsUndoAndSend').prop('checked', settings.actionsUndoAndSendChatterEnabled);
    			$('#chatterActionsEnvelopeSigning').prop('checked', settings.actionsEnvelopeSigningChatterEnabled);
    			// text
    			var languageInfo = chatterText.text;
    			$('#chatterEnvelopeSentText').val(languageInfo.envelopeSentChatterText);
    			$('#chatterEnvelopeDeliveredText').val(languageInfo.envelopeDeliveredChatterText);
    			$('#chatterEnvelopeCompletedText').val(languageInfo.envelopeCompletedChatterText);
    			$('#chatterEnvelopeDeclinedText').val(languageInfo.envelopeDeclinedChatterText);
    			$('#chatterEnvelopeVoidedText').val(languageInfo.envelopeVoidedChatterText);
    			$('#chatterRecipientSentText').val(languageInfo.recipientSentChatterText);
    			$('#chatterRecipientDeliveredText').val(languageInfo.recipientDeliveredChatterText);
    			$('#chatterRecipientCompletedText').val(languageInfo.recipientCompletedChatterText);
    			$('#chatterRecipientSignedText').val(languageInfo.recipientSignedChatterText);
    			$('#chatterRecipientDeclinedText').val(languageInfo.recipientDeclinedChatterText);
    		}
    	}
    }

    // Helper function for populating remind and expire settings
    function populateRemindExpireSettings(day) {
    	if(typeof(day) === 'undefined' || day === null || day === '-1') {
    		return '';
    	} 
    	return day;
    }

    // Helper function for formatting language label
    function formatLanguage(language) {
    	var result = '';
        var arr = language.split(' ');
        result = (arr.length > 1) ? arr[0] : language;
        result = result.charAt(0).toUpperCase() + result.toLowerCase().slice(1);
        return result;
    }


    // Helper function add email settings to UI
    function addEmailSetting(localizationSettings) {
    	console.log('addEmailSetting called.');
    	console.log(localizationSettings);
        var language = formatLanguage(localizationSettings.Language);
        var languageCode = localizationSettings.LanguageCode;
        var emailSubjectFull = (localizationSettings.DefaultEmailSubject === null) ? '' : localizationSettings.DefaultEmailSubject;
        var emailSubject = (emailSubjectFull.length > 100) ? emailSubjectFull.substring(0, 100) + '..' : emailSubjectFull;
        var emailBodyFull = (localizationSettings.DefaultEmailBody === null) ? '' : localizationSettings.DefaultEmailBody;
        var emailBody = (emailBodyFull.length > 200) ? emailBodyFull.substring(0, 200) + '..' : emailBodyFull;
        var html = '<div class="divided email-setting" id="'+languageCode+'"><div class="grid-row"><div class="three col"><p class="break">' +
		            language + '</p></div><div class="three col"><p class="break">' +
		            '<span class="sub-text" title="'+encodeSpecialCharacters(emailSubjectFull)+'">' +
		            encodeSpecialCharacters(emailSubject) + '</span></p></div><div class="six col editable"><p class="break">' + 
		            '<span class="sub-text" title="'+encodeSpecialCharacters(emailBodyFull)+'">' +
		            encodeSpecialCharacters(emailBody) + '</p><div class="controls">';
		if(languageCode !== 'en') {
			html += '<a href="javascript:void(0);" style="padding-left:8px;" class="delete" languageCode="'+languageCode+'">' + dsGlobal.deleteLabel + '</a>';
		}		
		html += '<a href="javascript:void(0);" class="edit" languageCode="'+languageCode+'">' + dsGlobal.editLabel + '</a></div></div></div></div>';
		$('.email-settings').append(html);
    }

    // Remove email setting from docusign localization settings list
    function removeDocuSignLocalizationSetting(languageCode) {
        console.log('removeDocuSignLocalizationSetting called, languageCode='+languageCode);
        var dslocalizationSettings = dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings;
        if(languageCode !== null && dslocalizationSettings !== null) {
            var localizationSettings = [];
            for(var i = 0; i < dslocalizationSettings.length; i++) {
                if(dslocalizationSettings[i].LanguageCode !== languageCode) {
                    localizationSettings.push(dslocalizationSettings[i]);
                }
            }
            dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings = localizationSettings;
        }
    }

    // Update email setting in the docusign localization settings list
    function updateDocuSignLocalizationSetting(localizationSettings) {
        console.log('updateDocuSignLocalizationSetting called');
        console.log(localizationSettings);
        if(localizationSettings !== null && dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings !== null) {
            for(var i = 0; i < dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings.length; i++) {
                if(dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings[i].LanguageCode === localizationSettings.LanguageCode) {
                    dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings[i].DefaultEmailSubject = localizationSettings.DefaultEmailSubject;
                    dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings[i].DefaultEmailBody = localizationSettings.DefaultEmailBody;
                    break;
                }
            }
        }
    }

    // Check if localization is available (already saved)
    function isLanguageAvailable(languageCode) {
		var localizationSettings = dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings;
		var localizationSetting;
		for(var i = 0; i < localizationSettings.length; i++) {
			if(localizationSettings[i].LanguageCode === languageCode) {
				return false;
			}
		}
		return true;
	}

    // Check the localization settings, hide the New button if no more available settings
    function checkLocalizationSettingsList() {
		if(dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings.length < 11) {
			$('#newLanguageSettingBtn').show();
		} else {
			$('#newLanguageSettingBtn').hide();
		}	
    }

	/*
	 * This function to encode special characters to html
	 * @param str  the string to be modified
	 */
	function encodeSpecialCharacters(str) {
	    if(!str) {
	        return '';
	    }        
	    return str.replace(/&/g, "&amp;").replace(/>/g, "&gt;").replace(/</g, "&lt;").replace(/"/g, "&quot;").replace(/'/g, "&lsquo;");   
	}

	// Click handler for deleting email settings
	$('.email-settings').on('click', '.delete', function() {
		var languageCode = $(this).attr('languageCode');
		console.log('Delete link clicked, languageCode=' + languageCode);
		$('#'+languageCode).css('opacity', '0.5');
		try {
	        Visualforce.remoting.Manager.invokeAction(
	            dsGlobal.deleteEmailSettings, languageCode,
	            function(result, event) {
	            	console.log(result);
	            	console.log(event);
	            	$('#'+languageCode).remove();
	            	removeDocuSignLocalizationSetting(languageCode);
	            	checkLocalizationSettingsList();
	            	console.log(dsGlobal.responseJson.admin.settings);
	            }
	        );
	    } catch (err) {
	        console.log(err);
	    }
	});

	// Click handler for editing email settings
	$('.email-settings').on('click', '.edit', function() {
		var languageCode = $(this).attr('languageCode');
		console.log('Edit link clicked, languageCode=' + languageCode);
		var localizationSettings = dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings;
		var localizationSetting;
		for(var i = 0; i < localizationSettings.length; i++) {
			if(localizationSettings[i].LanguageCode === languageCode) {
				localizationSetting = localizationSettings[i];
			}
		}
	    $('#languageSettingsDropdown').empty();
		$('#languageSettingsDropdown').append($('<option>', {
			value: localizationSetting.LanguageCode, text: formatLanguage(localizationSetting.Language)
		}));
		$('#defaultEmailSubject').val(localizationSetting.DefaultEmailSubject);
		$('#defaultEmailMessage').val(localizationSetting.DefaultEmailBody); 	
	    $('#languageSettingsDropdown').prop("disabled", true);
	    $('#languageSettingsDropdown').addClass('disabled');
	    $('.email-subject-error-label').hide();
	    $('#defaultEmailSubject').removeClass('error');
		$('#languageSettingsModal').show();
	});

	// Click handler for the "Save" button in language settings modal
	$('#saveLanguageSettingBtn').click(function() {
		var languageCode = $('#languageSettingsDropdown').val();
		var isEditing = $('#languageSettingsDropdown').prop("disabled");
		console.log('Save new email settings btn clicked, languageCode='+languageCode+',isEditing='+isEditing);
		if($('#defaultEmailSubject').val() === '') {
			$('.email-subject-error-label').show();
			$('#defaultEmailSubject').addClass('error');
			return;
		}
		var localizationSetting = {};
        var localizationSettings = dsGlobal.responseJson.admin.settings.availableLocalizationSettings;
        for(var i = 0; i < localizationSettings.length; i++) {
            if(localizationSettings[i].LanguageCode === languageCode) {
                localizationSetting.Deletable = localizationSettings[i].Deletable;
                localizationSetting.Language = localizationSettings[i].Language;
                localizationSetting.LanguageCode = localizationSettings[i].LanguageCode;
            }
        }
		localizationSetting.DefaultEmailSubject = $('#defaultEmailSubject').val();
		localizationSetting.DefaultEmailBody = $('#defaultEmailMessage').val();
		try {
	        Visualforce.remoting.Manager.invokeAction(
	            dsGlobal.saveEmailSettings, localizationSetting.LanguageCode, 
	            localizationSetting.DefaultEmailSubject, localizationSetting.DefaultEmailBody,
	            function(result, event) {
	            	console.log(result);
	            	console.log(event);
	            	var isEditing = $('#languageSettingsDropdown').prop("disabled");
	            	if(isEditing === true) {
						updateDocuSignLocalizationSetting(localizationSetting);
	            	} else {
	            		dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings.push(localizationSetting);
	            	}
	            	populateEmailSettings(dsGlobal.responseJson.admin.settings.docuSignLocalizationSettings);
	            	console.log(dsGlobal.responseJson.admin.settings);
					$('#languageSettingsModal').hide();
	            }
	        );
	    } catch (err) {
	        console.log(err);
	    }	
	});

    // Change handler for the chatter settings dropdown
    $('#dsChatterDropdown').change(function() {
    	console.log('Chatter Settings dropdown changed to ' + this.value);
    	if(this.value === 'Disabled') {
    		$('#chatter-settings').hide();
    		$('#dsChatterLanguageDropdown').hide();
    	} else {
    		$('#chatter-settings').show();
    		$('#dsChatterLanguageDropdown').show();
    	}
    });
    
    // change handler for chatter language dropdown
    $('#dsChatterLanguageDropdownSelect').change(function() {
    	console.log('Chatter Language Settings dropdown changed to ' + this.value);
		populateChatterEventSettings(dsGlobal.responseJson.admin.settings, this.value );
    });

    // Change handler for the Enable Reminder and Expiration Settings dropdown
    $('#reminderSettingsCheckbox').change(function() {
    	console.log('Reminder Settings checkbox changed to ' + $(this).prop('checked'));
    	if($(this).prop('checked') === true) {
    		$('#reminderSettings').show();
    	} else {
    		$('#reminderSettings').hide();
    	}
    });

    // Change handler for all Remind and Expire settings text inputs
    $('#remindSignersTextInput, #continueToSendRemindersTextInput, #expireRequestInTextInput, #warnSignersTextInput').change(function() {
    	console.log(this.id + ' text input is changed to ' + this.value );
        if(isNaN(this.value) || this.value < 0 || (this.value % 1) !== 0 || this.value.slice(-1) === '.') {
        	var settings = dsGlobal.responseJson.admin.settings;
        	if(this.id === 'remindSignersTextInput') {
        		$('#remindSignersTextInput').val(populateRemindExpireSettings(settings.reminderDays));
        	} else if(this.id === 'continueToSendRemindersTextInput') {
        		$('#continueToSendRemindersTextInput').val(populateRemindExpireSettings(settings.reminderRepeat));
        	} else if(this.id === 'expireRequestInTextInput') {
        		$('#expireRequestInTextInput').val(populateRemindExpireSettings(settings.expireDays));
        	} else if(this.id === 'warnSignersTextInput') {
        		$('#warnSignersTextInput').val(populateRemindExpireSettings(settings.expireWarning));
        	}
        }
    });

    // Click handler for "New" button in Email Settings of Settings tab
    $('#newLanguageSettingBtn').click(function() {
    	$('#languageSettingsDropdown').empty();
    	$('#languageSettingsDropdown').prop("disabled", false);
    	$('#languageSettingsDropdown').removeClass('disabled');
    	var localizationSettings = dsGlobal.responseJson.admin.settings.availableLocalizationSettings;
    	for(var i = 0; i < localizationSettings.length; i++) {
    		localizationSettings[i].Language = formatLanguage(localizationSettings[i].Language);
    	}
        localizationSettings.sort(function (a, b) {
			var x = a.Language.toLowerCase();
			var y = b.Language.toLowerCase();
			if (x > y) return 1;
			if (x < y) return -1;
			return 0;
		});
		var firstItemIsSet = false;
    	for(var i = 0; i < localizationSettings.length; i++) {
    		if(!isLanguageAvailable(localizationSettings[i].LanguageCode))
    			continue;
	    	$('#languageSettingsDropdown').append($('<option>', {
			    value: localizationSettings[i].LanguageCode,
			    text: localizationSettings[i].Language
			}));
    		if(!firstItemIsSet) {
				$('#defaultEmailSubject').val(localizationSettings[i].DefaultEmailSubject);
				$('#defaultEmailMessage').val(localizationSettings[i].DefaultEmailBody); 
				firstItemIsSet = true;
    		}
    	}
    	$('.email-subject-error-label').hide();
    	$('#defaultEmailSubject').removeClass('error');
    	$('#languageSettingsModal').show();
    });

    // Change handler for the New Email Settings dropdown
    $('#languageSettingsDropdown').change(function() {
    	var selectedVal = $(this).val();
    	console.log('New Email Settings dropdown is changed, selected value='+selectedVal);
     	var localizationSettings = dsGlobal.responseJson.admin.settings.availableLocalizationSettings;
    	for(var i = 0; i < localizationSettings.length; i++) {
    		if(localizationSettings[i].LanguageCode === selectedVal) {
    			console.log(localizationSettings[i].LanguageCode);
    			$('#defaultEmailSubject').val(localizationSettings[i].DefaultEmailSubject);
    			$('#defaultEmailMessage').val(localizationSettings[i].DefaultEmailBody);
    			break;
    		}
    	}    	
    });

    // Click handler for "Cancel" button and "X" icon in language settings modal
    $('#languageSettingsCloseIcon, #cancelLanguageSettingBtn').click(function() {
    	$('#languageSettingsModal').hide();
    });

    // Change handler for the default email subject
    $('#defaultEmailSubject').change(function() {
    	if($(this).val() !== '') {
    		$('.email-subject-error-label').hide();
    		$('#defaultEmailSubject').removeClass('error');
    	} else {
    		$('.email-subject-error-label').show();
    		$('#defaultEmailSubject').addClass('error');
    	}
    });

    // Click handler for the "Save" button in Settings tab
    $('#saveSettingsBtn').click(function() {
    	console.log('save settings button clicked.');
    	$('.fullscreenload').show();
    	var settings = dsGlobal.responseJson.admin.settings;
		try {
			// Update Email Settings
			settings.disableEmailSubjectEditing = $('#disableUserEmailSubjectCheckBox').prop('checked');
			settings.disableEmailMessageEditing = $('#disableUserEmailMessageCheckBox').prop('checked');
			settings.recipientRoleNames = $('#recipientRoleSettingsTextarea').val();
			// Update Send Settings
			settings.hideSendNowButton = $('#hideSendNowButton').prop('checked');
			settings.hideNextButton = $('#hideNextButton').prop('checked');
			settings.enableSFCalloutLimit = $('#enableSFCalloutLimit').prop('checked');
			settings.enableMobileAppForSF1 = $('#enableMobileTaggingUI').prop('checked');
			settings.displayTaggerPageInNewWindow = $('#displayTaggerPageInNewWindow').prop('checked');
			settings.displayInPersonSigningPageInNewWindow = $('#displayInPersonSigningPageInNewWindow').prop('checked');
			settings.enableRemindAndExpirationSettings = $('#reminderSettingsCheckbox').prop('checked');
			settings.hideRemindAndExpirationSettings = $('#hideRemindAndExpireSettings').prop('checked');
			settings.reminderDays = $('#remindSignersTextInput').val();
			settings.reminderRepeat = $('#continueToSendRemindersTextInput').val();
			settings.expireDays = $('#expireRequestInTextInput').val();
			settings.expireWarning = $('#warnSignersTextInput').val();
			// Update Chatter Settings
			settings.chatterSettingCode = $('#dsChatterDropdown').val();
			settings.envelopeSentChatterEnabled = $('#chatterEnvelopeSentCheckbox').prop('checked');
			settings.envelopeDeliveredChatterEnabled = $('#chatterEnvelopeDeliveredCheckbox').prop('checked');
			settings.envelopeCompletedChatterEnabled = $('#chatterEnvelopeCompletedCheckbox').prop('checked');
			settings.envelopeDeclinedChatterEnabled = $('#chatterEnvelopeDeclinedCheckbox').prop('checked');
			settings.envelopeVoidedChatterEnabled = $('#chatterEnvelopeVoidedCheckbox').prop('checked');
			settings.recipientSentChatterEnabled = $('#chatterRecipientSentCheckbox').prop('checked');
			settings.recipientDeliveredChatterEnabled = $('#chatterRecipientDeliveredCheckbox').prop('checked');
			settings.recipientCompletedChatterEnabled = $('#chatterRecipientCompletedCheckbox').prop('checked');
			settings.recipientSignedChatterEnabled = $('#chatterRecipientSignedCheckbox').prop('checked');
			settings.recipientDeclinedChatterEnabled = $('#chatterRecipientDeclinedCheckbox').prop('checked');
			
			settings.actionsUndoAndSendChatterEnabled = $('#chatterActionsUndoAndSend').prop('checked');
			console.log('Save Button Click function settings.actionsUndoAndSendChatterEnabled :'+settings.actionsUndoAndSendChatterEnabled);
			settings.actionsEnvelopeSigningChatterEnabled = $('#chatterActionsEnvelopeSigning').prop('checked');
			console.log('Save Button Click function settings.chatterActionsEnvelopeSigning :'+settings.actionsEnvelopeSigningChatterEnabled);
			
			var chatterSettings = dsGlobal.responseJson.admin.settings.chatterTextDto;
			for(var i = 0; i < chatterSettings.length; i++) {
				var currentLanguageSettings = chatterSettings[i];
				if (currentLanguageSettings.LanguageCode === dsGlobal.chatterLanguageCodeText) { 
					var that = currentLanguageSettings.text;
					that.envelopeSentChatterText = $('#chatterEnvelopeSentText').val();
					that.envelopeDeliveredChatterText = $('#chatterEnvelopeDeliveredText').val();
					that.envelopeCompletedChatterText = $('#chatterEnvelopeCompletedText').val();
					that.envelopeDeclinedChatterText = $('#chatterEnvelopeDeclinedText').val();
					that.envelopeVoidedChatterText = $('#chatterEnvelopeVoidedText').val();
					that.recipientSentChatterText = $('#chatterRecipientSentText').val();
					that.recipientDeliveredChatterText = $('#chatterRecipientDeliveredText').val();
					that.recipientCompletedChatterText = $('#chatterRecipientCompletedText').val();
					that.recipientSignedChatterText = $('#chatterRecipientSignedText').val();
					that.recipientDeclinedChatterText = $('#chatterRecipientDeclinedText').val();
				}
			}

            Visualforce.remoting.Manager.invokeAction(
                dsGlobal.updateSettings, settings,
                function(result, event) {
                	console.log(result);
                	console.log(event);
                	$('.fullscreenload').hide();
                	showMessages(result.messages);
					if (result.action == "ShowSuccess") {
						$("#dsChatterLanguageDropdown [value='"+ dsGlobal.chatterLanguageCodeText + "']").prop("selected", "selected");
					}
                }
            );
        } catch (err) {
        	$('.fullscreenload').hide();
            console.log(err);
        }
    })  
    
    
  /*  New Custom Tag */
  
 	//Name mandatory field
  	 $('#newCustomTagCreation').click(function() {
    	if($(customTagNameText).val() !== '') {
    	   //alert('Not Empty');
    	    console.log('Not Empty');
    		$(customTagNameText).css({"border-color": "", 
             "border-width":"", 
             "border-style":""});
    		
    	} else {
    		//alert('Empty');
    		 console.log('Empty');
    		$(customTagNameText).css({"border-color": "#E86B52", 
             "border-width":"1px", 
             "border-style":"solid"});
    		
    	}
    	if( $(relateFieldToSalesforceCheckbox).is(':checked')) {
    	 	if($(salesforceObjectDropDown).val() !== "NaNval"){
    	 		$(salesforceObjectDropDown).css({"border-color": "", 
            	 "border-width":"", 
             	"border-style":""});
    	 	}
    	 	else{
    	 	 $(salesforceObjectDropDown).css({"border-color": "#E86B52", 
             "border-width":"1px", 
             "border-style":"solid"});
    	 	}
    	 }
    	 else{
    	 	$(salesforceObjectDropDown).css({"border-color": "", 
            	 "border-width":"", 
             	"border-style":""});
    	 }
    });
     $('#customTagNameText').change(function() {
    	if($(customTagNameText).val() !== '') {
    		$(customTagNameText).css({"border-color": "", 
             "border-width":"", 
             "border-style":""});
    		
    	} else {
    		 console.log('Empty');
    		$(customTagNameText).css({"border-color": "#E86B52", 
             "border-width":"1px", 
             "border-style":"solid"});
    		
    	}
    	
    	 
    });
  	// width and hight should accept numbers only
  	 $('#widthText').keypress(function(e) {
  	 	console.log("Key press event")
            var verified = (e.which == 8 || e.which == undefined || e.which == 0) ? null : String.fromCharCode(e.which).match(/[^0-9]/);
            if (verified) {e.preventDefault();}
    });
     $('#heightText').keypress(function(e) {
  	 	console.log("Key press event")
            var verified = (e.which == 8 || e.which == undefined || e.which == 0) ? null : String.fromCharCode(e.which).match(/[^0-9]/);
            if (verified) {e.preventDefault();}
    });
    
    // Handle visibility for relate to salesforce field
	 $('#relateFieldToSalesforceCheckbox').click(function() {
	 
        if( $(this).is(':checked')) {
            $('#relateFieldToSalesforce').show();
            try {
            	$('#firstLevelFieldSetDropDown').empty();
            	$('#firstLevelFieldSetDropDown').hide();
	            //pulling first level objects
	            Visualforce.remoting.Manager.invokeAction(
	                dsGlobal.getAllSalesforceObjects,
	                function(result, event) {
	                	console.log('getAllSalesforceObjects :'+result);
	                	console.log(event);
	                	$('.fullscreenload').hide();
	                	showMessages(result.messages);
						$.map(result.admin.customTag.allSalesforceObjects, function(key, value) {
								$('#salesforceObjectDropDown').append($("<option></option>").attr("value",value).text(key));
						});
	                }
	            );
            } catch (err) {
	            console.log(err);
	        }
        } else {
            $('#relateFieldToSalesforce').hide();
             $('#salesforceObjectDropDown').empty();
             $('#firstLevelFieldSetDropDown').hide();
             $('#firstLevelFieldSetDropDown').empty();
             $('#secondLevelFieldSetDropDown').hide();
             $('#secondLevelFieldSetDropDown').empty();
             $('#thirdLevelFieldSetDropDown').hide();
             $('#thirdLevelFieldSetDropDown').empty();
		    
        }
    }); 
    
    //Change handler for related to salesforce checkbox first level dropdown
     $('#salesforceObjectDropDown').change(function() {
     	$('#firstLevelFieldSetDropDown').empty();
     	$('#firstLevelFieldSetDropDown').show();
     	$('#secondLevelFieldSetDropDown').hide();
        $('#secondLevelFieldSetDropDown').empty();
        $('#thirdLevelFieldSetDropDown').empty();
	 	$('#thirdLevelFieldSetDropDown').hide();
     	try {
     		var objName = $('#salesforceObjectDropDown').val();
     		console.log('salesforceObjectDropDown : '+objName);
	            //pulling first level objects
	            Visualforce.remoting.Manager.invokeAction(
	                dsGlobal.getLevelFieldSet,objName,1,
	                function(result, event) {
	                	console.log('getFirstLevelFieldSet :'+result);
	                	console.log(event);
	                	$('.fullscreenload').hide();
	                	showMessages(result.messages);
						$.map(result.admin.customTag.firstLevelFieldSet, function(key, value) {
								$('#firstLevelFieldSetDropDown').append($("<option></option>").attr("value",value).text(key));
						});
	                }
	            );
            } catch (err) {
	            console.log(err);
	        }
     
     }); 
     
     //Change handler for related to second level dropdown
     $('#firstLevelFieldSetDropDown').change(function() {
     
     resetDivVisibility();
  	 $('#secondLevelFieldSetDropDown').hide();
     $('#secondLevelFieldSetDropDown').empty();
     $('#thirdLevelFieldSetDropDown').empty();
	 $('#thirdLevelFieldSetDropDown').hide();
	 
     var objName = $('#firstLevelFieldSetDropDown').val();
     var arr = objName.split('|');
     console.log('F arr[0] : '+arr[0]);
     console.log('F arr[1] : '+arr[1]);
     if((arr[1].trim()==='reference') || (arr[1].trim()==='child_relationship')){
		     $('#secondLevelFieldSetDropDown').empty();
		     $('#secondLevelFieldSetDropDown').show();
		     	try {
		     		
		     		console.log('firstLevelFieldSetDropDown : '+objName);
		     		console.log('firstLevelFieldSetDropDown parameter : '+arr[0].trim());
			            //pulling first level objects
			            Visualforce.remoting.Manager.invokeAction(
			                dsGlobal.getLevelFieldSet,arr[0].trim(), 2,
			                function(result, event) {
			                	console.log('secondLevelFieldSet :'+result);
			                	console.log(event);
			                	$('.fullscreenload').hide();
			                	showMessages(result.messages);
								$.map(result.admin.customTag.firstLevelFieldSet, function(key, value) {
										$('#secondLevelFieldSetDropDown').append($("<option></option>").attr("value",value).text(key));
								});
			                }
			            );
		            } catch (err) {
			            console.log(err);
			        }
			}
		else{
			$('#secondLevelFieldSetDropDown').empty();
			$('#secondLevelFieldSetDropDown').hide();
        	
        	
			var selectedVal = arr[1];
			console.log('selectedVal : '+selectedVal);
    		if(selectedVal === 'picklist')
    			selectedVal='Drop Down';
    			
    		if(selectedVal === 'string' || selectedVal === 'double' || selectedVal === 'boolean' 
    		|| selectedVal === 'currency' || selectedVal === 'int' || selectedVal === 'textarea'
    		|| selectedVal === 'phone' || selectedVal === 'url'|| selectedVal === 'address')
    			selectedVal='Text Field';
    		
    		$('#tagTypeDropdown').val(selectedVal);
    		console.log('Tag Type dropdown is changed, selected value='+selectedVal);
	    	
	    	//handle visibility for all six divs
	    	
	    	handleCustomTagDiv(selectedVal);    
	    	handleFormattingDiv(selectedVal);
	    	handleTooltipDiv(selectedVal);
	    	handleValidation(selectedVal);
	    	handleInputLimitDiv(selectedVal);
	    	handleAdvancedDiv(selectedVal);
		}
     
     }); 
    
    //Change handler for related to second level dropdown
     $('#secondLevelFieldSetDropDown').change(function() {
     
     resetDivVisibility();
     $('#thirdLevelFieldSetDropDown').empty();
	 $('#thirdLevelFieldSetDropDown').hide();
     
     var objName = $('#secondLevelFieldSetDropDown').val();
     var arr = objName.split('|');
      console.log('S arr[0] : '+arr[0]);
      console.log('S arr[1] : '+arr[1]);
     if((arr[1].trim()==='reference') || (arr[1].trim()==='child_relationship')){
		     $('#thirdLevelFieldSetDropDown').empty();
		     $('#thirdLevelFieldSetDropDown').show();
		     	try {
		     		
		     		console.log('secondLevelFieldSetDropDown : '+objName);
		     		console.log('secondLevelFieldSetDropDown parameter : '+arr[0].trim());
			            //pulling first level objects
			            Visualforce.remoting.Manager.invokeAction(
			                dsGlobal.getLevelFieldSet,arr[0].trim(),3,
			                function(result, event) {
			                	console.log('secondLevelFieldSet :'+result);
			                	console.log(event);
			                	$('.fullscreenload').hide();
			                	showMessages(result.messages);
								$.map(result.admin.customTag.firstLevelFieldSet, function(key, value) {
										$('#thirdLevelFieldSetDropDown').append($("<option></option>").attr("value",value).text(key));
								});
			                }
			            );
		            } catch (err) {
			            console.log(err);
			        }
			}
		else{
			$('#thirdLevelFieldSetDropDown').empty();
			$('#thirdLevelFieldSetDropDown').hide();
        	
        	
			var selectedVal = arr[1];
			console.log('selectedVal : '+selectedVal);
    		if(selectedVal === 'picklist')
    			selectedVal='Drop Down';
    			
    		if(selectedVal === 'string' || selectedVal === 'double' || selectedVal === 'boolean' 
    		|| selectedVal === 'currency' || selectedVal === 'int' || selectedVal === 'textarea'
    		|| selectedVal === 'phone' || selectedVal === 'url'|| selectedVal === 'address')
    			selectedVal='Text Field';
    		
    		$('#tagTypeDropdown').val(selectedVal);
    		console.log('Tag Type dropdown is changed, selected value='+selectedVal);
	    	
	    	//handle visibility for all six divs
	    	
	    	handleCustomTagDiv(selectedVal);    
	    	handleFormattingDiv(selectedVal);
	    	handleTooltipDiv(selectedVal);
	    	handleValidation(selectedVal);
	    	handleInputLimitDiv(selectedVal);
	    	handleAdvancedDiv(selectedVal);
		}
     
     }); 
     
      $('#thirdLevelFieldSetDropDown').change(function() {
     
     resetDivVisibility();
     var objName = $('#thirdLevelFieldSetDropDown').val();
     var arr = objName.split('|');
     console.log('T arr[0] : '+arr[0]);
     console.log('T arr[1] : '+arr[1]);
     console.log('secondLevelFieldSetDropDown : '+objName);
	 console.log('secondLevelFieldSetDropDown parameter : '+arr[0].trim());
     if((arr[1].trim()==='reference') || (arr[1].trim()==='child_relationship')){
		     
	 }
	 else{
        	
			var selectedVal = arr[1];
			console.log('selectedVal : '+selectedVal);
    		if(selectedVal === 'picklist')
    			selectedVal='Drop Down';
    			
    		if(selectedVal === 'string' || selectedVal === 'double' || selectedVal === 'boolean' 
    		|| selectedVal === 'currency' || selectedVal === 'int' || selectedVal === 'textarea'
    		|| selectedVal === 'phone' || selectedVal === 'url'|| selectedVal === 'address')
    			selectedVal='Text Field';
    		
    		$('#tagTypeDropdown').val(selectedVal);
    		console.log('Tag Type dropdown is changed, selected value='+selectedVal);
	    	
	    	//handle visibility for all six divs
	    	
	    	handleCustomTagDiv(selectedVal);    
	    	handleFormattingDiv(selectedVal);
	    	handleTooltipDiv(selectedVal);
	    	handleValidation(selectedVal);
	    	handleInputLimitDiv(selectedVal);
	    	handleAdvancedDiv(selectedVal);
		}
     
     }); 
    //Change handler for Validation Type Dropdown
    
    $('#validationTypeDropdown').change(function() {
    	var validationTypeVal = $(this).val();
    	console.log('Tag Type dropdown is changed, selected value='+validationTypeVal);
    	switch (validationTypeVal) { 
			case 'Regular Expression': 
						$('#newCustomTagValidation').show();
						$('#validationTypeDiv').show();
						$('#RegExPatternDiv').show();
						$('#ValidationErrorMessageDiv').show();
						break;
			default:	
						$('#newCustomTagValidation').show();
						$('#validationTypeDiv').show();
						$('#RegExPatternDiv').hide();
						$('#ValidationErrorMessageDiv').show();	
			}	
    });
    
	// Change handler for the Tag Type in newCustomTag
    $('#tagTypeDropdown').change(function() {
    	
    	var selectedVal = $(this).val();
    	console.log('Tag Type dropdown is changed, selected value='+selectedVal);
    	
    	//handle visibility for all six divs
    	resetDivVisibility();
    	handleCustomTagDiv(selectedVal);    
    	handleFormattingDiv(selectedVal);
    	handleTooltipDiv(selectedVal);
    	handleValidation(selectedVal);
    	handleInputLimitDiv(selectedVal);
    	handleAdvancedDiv(selectedVal);
    	
    	    	
    });
    function resetDivVisibility(){
     	var selectedVal='Text Field';
    	$('#tagTypeDropdown').val(selectedVal);
    
	    $('#newCustomTagInfo').show();
	    $('#initialValue').show();
	 	$('#requiredField').show();
	 	$('#readOnly').show();
	 	$('#shared').show();
	 	$('#Options').hide();
	 	
	    $('#newCustomTagFormat').show();
	    $('#fontDiv').show();
		$('#widthHeightDiv').show();
		$('#widthHeightDiv').hide();
		$('#hideWithAstericksDiv').show();
		
	    $('#newCustomTagToolTip').show();
	    
	    $('#newCustomTagValidation').show();
		$('#validationTypeDiv').show();
		$('#RegExPatternDiv').hide();
		$('#ValidationErrorMessageDiv').show();
		$('#validationTypeDropdown').val('No Validation');
	    
	    $('#newCustomTagInputLimit').show();
	    $('#maxCharacters').show();
		$('#charactersPerLine').show();
		$('#lines').show();
		
	    $('#newCustomTagAdvanced').show();
	    $('#fixedSizeDiv').show();
		$('#includeNoteInEmailDiv').hide();
    
    }
    //Handler for Custom tag Div
    function handleCustomTagDiv(tagType){
    	switch (tagType) { 
			case 'Approve': 
				 	$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'Checkbox': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'Company': break;
			
			case 'Date Signed': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
			
			case 'Email': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	
				 	break;
			 	
			case 'Decline': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
			
			case 'Drop Down': 
					$('#initialValue').show();
				 	$('#requiredField').show();
				 	$('#readOnly').show();
				 	$('#Options').show();
				 	break;
				 	
			case 'Envelope ID': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'First Name': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'Formula': break;
				 			 	
			case 'Full Name': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'Initial Here': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'Initial Here Optional': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'Last Name': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;	
				 		
			case 'Note': 
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;
				 	
			case 'Sign Here': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;	
				 	
			case 'Sign Here Optional': 
					$('#initialValue').hide();
				 	$('#requiredField').hide();
				 	$('#readOnly').hide();
				 	$('#Options').hide();
				 	break;	
				 	
			case 'Radio Button': 
								$('#Options').hide();
								$('#initialValue').hide();
								break; 
			
			case 'Signer Attachment': $('#Options').hide();break;
			
			case 'Title': $('#Options').hide();break;		
				 	
			default:
					$('#initialValue').show();
				 	$('#requiredField').show();
				 	$('#readOnly').show();
				 	$('#shared').show();
				 	$('#Options').hide();
		}
    
    }
    //Handler for Formatting Div
    function handleFormattingDiv(tagType){
    	switch (tagType) { 
			case 'Approve':$('#widthHeightDiv').show();
						   $('#hideWithAstericksDiv').hide();
							break;
			case 'Checkbox':
							$('#hideWithAstericksDiv').hide();
							break;
							
			case 'Company':
							$('#hideWithAstericksDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
							
			case 'Date Signed': 
							$('#hideWithAstericksDiv').hide();
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							
							break;
							
			case 'Decline':$('#widthHeightDiv').show();
							$('#hideWithAstericksDiv').hide();
							break;
			
			case 'Drop Down':
							$('#widthHeightDiv').show();
							$('#newCustomTagFormat').show();
							$('#fontDiv').show();
							$('#hideWithAstericksDiv').hide();
							break;
							
			case 'Email':
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							break;
			
			case 'First Name':
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
			case 'Formula': 
							$('#newCustomTagFormat').show();
							$('#fontDiv').show();
							break;
			case 'Full Name': 
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
			case 'Envelope ID': 
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
			case 'Initial Here': 
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
			case 'Initial Here Optional': 
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
			case 'Last Name':
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
			case 'Note':
							$('#newCustomTagFormat').show();
							$('#fontDiv').show();
							$('#widthHeightDiv').show();
							$('#hideWithAstericksDiv').hide();
							break;
			case 'Sign Here':
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;
							
			case 'Sign Here Optional':
							$('#newCustomTagFormat').hide();
							$('#fontDiv').hide();
							$('#hideWithAstericksDiv').hide();
							break;		
									
			case 'Radio Button': 
							$('#hideWithAstericksDiv').hide();
							break;
			
			case 'Signer Attachment': 
							$('#newCustomTagFormat').show();
							$('#fontDiv').show();
							break;	
							
			case 'Title': 
							$('#newCustomTagFormat').show();
							$('#fontDiv').show();
							$('#hideWithAstericksDiv').hide();
							break;	
			
			default:
					$('#newCustomTagFormat').show();
					$('#fontDiv').show();
					$('#widthHeightDiv').hide();
					$('#hideWithAstericksDiv').show();
		}
    
    }
     //Handler for Tooltip Div
    function handleTooltipDiv(tagType){
    	switch (tagType) { 
			case 'Approve': break;
			case 'Checkbox': break;
			case 'Company': break;
			case 'Date Signed': break;
			case 'Drop Down': $('#newCustomTagToolTip').hide();break;
			case 'Decline': break;
			case 'Email':break; 
			case 'Envelope ID':break; 
			case 'First Name':break;
			case 'Formula': break;
			case 'Full Name':break;
			case 'Initial Here':break;
			case 'Initial Here Optional':break;
			case 'Last Name':break;
			case 'Note':break;
			case 'Radio Button': break;
			case 'Sign Here': break;
			case 'Sign Here Optional': break;
			case 'Signer Attachment': break;
			case 'Title': break;
			default:
					$('#newCustomTagToolTip').show();
		}
    
    }
     //Handler for Validation Div
      function handleValidation(tagType){
    	switch (tagType) { 
			case 'Approve': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Checkbox': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							 break;
			case 'Company': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							 break;
			case 'Date Signed': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Decline': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Drop Down':$('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Email': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Envelope ID': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;	
			case 'First Name': $('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;		
			case 'Formula': $('#newCustomTagValidation').show();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').show();	
							break;	 
			case 'Full Name': 
							$('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Initial Here': 
							$('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Initial Here Optional': 
							$('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							 break;
			case 'Last Name': 
							$('#newCustomTagValidation').hide();
							$('#validationTypeDiv').hide();
							$('#RegExPatternDiv').hide();
							$('#ValidationErrorMessageDiv').hide();	
							break;
			case 'Note': 
						$('#newCustomTagValidation').hide();
						$('#validationTypeDiv').hide();
						$('#RegExPatternDiv').hide();
						$('#ValidationErrorMessageDiv').hide();	
						break;
			case 'Radio Button': 
						$('#newCustomTagValidation').hide();
						$('#validationTypeDiv').hide();
						$('#RegExPatternDiv').hide();
						$('#ValidationErrorMessageDiv').hide();	
						break;
			case 'Sign Here': 
						$('#newCustomTagValidation').hide();
						$('#validationTypeDiv').hide();
						$('#RegExPatternDiv').hide();
						$('#ValidationErrorMessageDiv').hide();	
						break;
			case 'Sign Here Optional': 
						$('#newCustomTagValidation').hide();
						$('#validationTypeDiv').hide();
						$('#RegExPatternDiv').hide();
						$('#ValidationErrorMessageDiv').hide();	
					 	break;
			case 'Signer Attachment': 
						$('#newCustomTagValidation').show();
						$('#validationTypeDiv').hide();
						$('#RegExPatternDiv').hide();
						$('#ValidationErrorMessageDiv').show();	
						break;
			case 'Title': 
						$('#newCustomTagValidation').hide();
						$('#validationTypeDiv').hide();
						$('#RegExPatternDiv').hide();
						$('#ValidationErrorMessageDiv').hide();	
						break;
			default:
					$('#newCustomTagValidation').show();
					$('#validationTypeDiv').show();
					$('#RegExPatternDiv').hide();
					$('#ValidationErrorMessageDiv').show();	
		}
    
    }
     
     //Handler for InputLimit Div
     function handleInputLimitDiv(tagType){
    	switch (tagType) { 
			case 'Approve': 
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Checkbox':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Company': 
							$('#newCustomTagInputLimit').show();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').show();
							break;
			case 'Date Signed':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Decline': 
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Drop Down': 
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Email':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Envelope ID':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'First Name':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Formula': 
							$('#newCustomTagInputLimit').show();
							$('#maxCharacters').show();
							$('#charactersPerLine').show();
							$('#lines').hide();
							break;
			case 'Full Name':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Initial Here':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Initial Here Optional':
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Last Name': 
							$('#newCustomTagInputLimit').hide();		
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Note': 	
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
			case 'Radio Button': 
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
							
			case 'Sign Here': 
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
							
			case 'Sign Here Optional': 
							$('#newCustomTagInputLimit').hide();
							$('#maxCharacters').hide();
							$('#lines').hide();
							$('#charactersPerLine').hide();
							break;
							
			case 'Signer Attachment': 
							$('#newCustomTagInputLimit').show();
							$('#maxCharacters').show();
							$('#charactersPerLine').show();
							$('#lines').hide();
							break;
							
			case 'Title': 
							$('#newCustomTagInputLimit').show();
							$('#maxCharacters').hide();
							$('#charactersPerLine').show();
							$('#lines').hide();
							break;
			default:
					$('#newCustomTagInputLimit').show();
					$('#maxCharacters').show();
					$('#lines').show();
					$('#charactersPerLine').show();
		}
    
    }
     
     //Handler for Addvanced Div
     function handleAdvancedDiv(tagType){
    	switch (tagType) { 
			case 'Approve': 
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Checkbox':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Company':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Date Signed':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;	
			case 'Decline':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Drop Down':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Email':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Envelope ID':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'First Name': 
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;	
			case 'Formula':
							$('#newCustomTagAdvanced').show();  
							$('#fixedSizeDiv').show();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Full Name':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;	
			case 'Initial Here':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Initial Here Optional':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Last Name':
							$('#newCustomTagAdvanced').hide();  
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;	
			case 'Note': 	 $('#newCustomTagAdvanced').show();
							 $('#fixedSizeDiv').hide();
							 $('#includeNoteInEmailDiv').show();
							 break;	
			case 'Radio Button':
							$('#newCustomTagAdvanced').hide(); 
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Sign Here':
							$('#newCustomTagAdvanced').hide();  
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Sign Here Optional':
							$('#newCustomTagAdvanced').hide();  
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Signer Attachment':
							$('#newCustomTagAdvanced').show();  
							$('#fixedSizeDiv').show();
							$('#includeNoteInEmailDiv').hide();
							break;
			case 'Title':
							$('#newCustomTagAdvanced').hide();  
							$('#fixedSizeDiv').hide();
							$('#includeNoteInEmailDiv').hide();
							break;				
			default:
					$('#newCustomTagAdvanced').show();
					$('#fixedSizeDiv').show();
					$('#includeNoteInEmailDiv').hide();
		}
    
    }  
});
