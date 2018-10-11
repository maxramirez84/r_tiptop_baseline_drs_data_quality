library(redcapAPI)

api_url = "https://tiptop.isglobal.org/redcap/api/"
api_token = "XXXXXX" # TIPTOP SP-Monitoring Baseline 

# Export data from REDCap
rcon = redcapConnection(api_url, api_token)
drs_data = exportRecords(rcon, factors = F)

# Remove DEC entries (--1 and --2) and keep only merged entries
drs_data = drs_data[!grepl('--1', drs_data$record_id), ]
drs_data = drs_data[!grepl('--2', drs_data$record_id), ]

# Remove records which represent non-recruited patients. I.e. they do not have study number
drs_data = drs_data[!is.na(drs_data$study_number), ]

# Compute profile
profile = table(drs_data$area, drs_data$facility)
print(profile)

# Compute duplicates (study_number)
duplicates = drs_data[duplicated(drs_data$study_number) | 
                        duplicated(drs_data$study_number, fromLast = T), ]
duplicates = duplicates[order(duplicates$study_number), ]
print(unique(duplicates$study_number))

# Verify the integrity of study numbers (match with area and facility)
wrong_study_numbers_initial = drs_data[substr(drs_data$study_number, 8, 8) == 'I' & drs_data$area != 1, ]
wrong_study_numbers_control = drs_data[substr(drs_data$study_number, 8, 8) == 'C' & drs_data$area != 2, ]
wrong_study_numbers_facility = drs_data[substr(drs_data$study_number, 9, 9) != drs_data$facility, ]

