/* 
Created by Jelena Dyčenko on 03/2021
 
The Diploma thesis: Relationship Between Objective and Subjective Well-Being.
 
The report is an attempt to summarize international experience in search of answers to measuring people’s well-being by looking at the relationship between the subjective and objective well-being per individual.
*/


drop _all

use "data.dta"


*** summaries ***
* summary of all transformed metrics used to calculate HWBI
sum college_degree high_school_copmpletion psych_problems distress_scale frequency_of_alcohol_consumption frequency_of_smoking perceived_health changes_in_health vacation physical_activity mental_activity leisure_activity adults_working_long_hours food_security income_per_year if_earned_money home_value mortgage_debt_remaining work_pressure frequency_of_meals_together volunteeringordonating frequency_of_interaction_with_pe frequency_of_recreation

* summary of 5 domains of HWBI
sum d1 d2 d3 d4 d5

* summary of HWBI measured with and without life satisfaction
sum HWBI HWBIwithlifesatisfaction


* distributions of HWBI and life satisfaction
histogram HWBI
histogram life_satisfaction_inv

* correlation between HWBI and life satisfaction
pwcorr HWBI life_satisfaction_inv, sig
* Result: there exists a significantly positive correlation

* regression of life_satisfaction to HWBI metrics
reg life_satisfaction_inv college_degree high_school_copmpletion psych_problems distress_scale frequency_of_alcohol_consumption frequency_of_smoking perceived_health changes_in_health vacation physical_activity mental_activity leisure_activity adults_working_long_hours food_security income_per_year if_earned_money home_value mortgage_debt_remaining work_pressure frequency_of_meals_together volunteeringordonating frequency_of_interaction_with_pe frequency_of_recreation
* Result: sample size is 8863 observations. Since the significance level is set to 5%, the p-value is significant. R^2 = 0.1787 the model describes 17,86% of the variance of life satisfaction

* correlation by gender (0-male, 1-female) and marital status (1-married, 2-never married, 3-widowed, 4-divorced, 5-separated)
corr HWBI life_satisfaction_inv if marital_status == 1 & gender == 0
corr HWBI life_satisfaction_inv if marital_status == 1 & gender == 1

corr HWBI life_satisfaction_inv if marital_status == 2 & gender == 0
corr HWBI life_satisfaction_inv if marital_status == 2 & gender == 1

corr HWBI life_satisfaction_inv if marital_status == 3 & gender == 0
corr HWBI life_satisfaction_inv if marital_status == 3 & gender == 1

corr HWBI life_satisfaction_inv if marital_status == 4 & gender == 0
corr HWBI life_satisfaction_inv if marital_status == 4 & gender == 1

corr HWBI life_satisfaction_inv if marital_status == 5 & gender == 0
corr HWBI life_satisfaction_inv if marital_status == 5 & gender == 1
* Result: there is a difference between the male and female results for married people, where for female gender the correlation of subjective and objective well-being almost disappears

* correlation by gender (0-male, 1-female) and age groups
corr HWBI life_satisfaction_inv if young_adults == 1 & gender == 0
corr HWBI life_satisfaction_inv if young_adults == 1 & gender == 1

corr HWBI life_satisfaction_inv if middle_aged_adults == 1 & gender == 0
corr HWBI life_satisfaction_inv if middle_aged_adults == 1 & gender == 1

corr HWBI life_satisfaction_inv if older_adults == 1 & gender == 0
corr HWBI life_satisfaction_inv if older_adults == 1 & gender == 1
* Result: the correlation is higher for males than females


*** Chow test ***
* 1 step: generation of dummies for males
gen male = 0
replace male = 1 if gender == 0

* 2 step: creation of the new data set for males
gen m_college_degree = male * college_degree  
gen m_high_school_copmpletion = male * high_school_copmpletion
gen m_psych_problems  = male * psych_problems
gen m_distress_scale = male * distress_scale
gen m_frequency_of_alcohol_cons = male * frequency_of_alcohol_consumption
gen m_frequency_of_smoking = male * frequency_of_smoking
gen m_perceived_health = male * perceived_health
gen m_changes_in_health = male * changes_in_health
gen m_vacation = male * vacation
gen m_physical_activity = male * physical_activity
gen m_mental_activity = male * mental_activity
gen m_leisure_activity = male * leisure_activity
gen m_adults_working_long_hours = male * adults_working_long_hours
gen m_food_security = male * food_security 
gen m_income_per_year = male * income_per_year
gen m_if_earned_money = male * if_earned_money
gen m_home_value = male * home_value
gen m_mortgage_debt_remaining = male * mortgage_debt_remaining
gen m_work_pressure = male * work_pressure
gen m_frequency_of_meals_together = male * frequency_of_meals_together
gen m_volunteeringordonating = male * volunteeringordonating
gen m_frequency_of_interaction =  male * frequency_of_interaction_with_pe
gen m_frequency_of_recreation = male * frequency_of_recreation

* 3 step: regression on two data sets
reg life_satisfaction_inv college_degree high_school_copmpletion  psych_problems distress_scale frequency_of_alcohol_consumption frequency_of_smoking perceived_health changes_in_health vacation physical_activity mental_activity leisure_activity adults_working_long_hours food_security income_per_year if_earned_money home_value mortgage_debt_remaining work_pressure frequency_of_meals_together volunteeringordonating frequency_of_interaction_with_pe frequency_of_recreation m_college_degree m_high_school_copmpletion  m_psych_problems m_distress_scale m_frequency_of_alcohol_cons m_frequency_of_smoking m_perceived_health m_changes_in_health m_vacation m_physical_activity m_mental_activity m_leisure_activity m_adults_working_long_hours m_food_security m_income_per_year m_if_earned_money m_home_value m_mortgage_debt_remaining m_work_pressure m_frequency_of_meals_together m_volunteeringordonating m_frequency_of_interaction m_frequency_of_recreation male 
* Result: behavior between genders is not the same for variables: frequency of smoking, perceived health and frequency of meals together 

* 4 step: running the Chow test
test m_college_degree m_high_school_copmpletion m_psych_problems m_distress_scale m_frequency_of_alcohol_cons m_frequency_of_smoking m_perceived_health m_changes_in_health m_vacation m_physical_activity m_mental_activity m_leisure_activity m_adults_working_long_hours m_food_security m_income_per_year m_if_earned_money m_home_value m_mortgage_debt_remaining m_work_pressure m_frequency_of_meals_together m_volunteeringordonating m_frequency_of_interaction m_frequency_of_recreation male
* Result: p-value is significant, so H0 hypothesis is rejected, this means that globally the relationship of HWBI metrics to life satisfaction for men is significantly different than for women