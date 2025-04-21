' Pindyck & Rubinfeld (1998, p.390)
' Simple Macroeconomic model of the U.S. economy
wfopen Z:\DATABANK\CONSUMPTION\macromod.wf1
' Estimating the Equations
smpl @all
equation eqcn.ls cn c y cn(-1)
equation eqi.ls i c y(-1)-y(-2) y r(-4)
equation eqr.ls r c y y-y(-1) m-m(-1) r(-1)+r(-2)
' Creating the Model
model model1
'' Linking the Equations
model1.merge eqi
model1.merge eqcn
model1.merge eqr
'' Adding the Identity
model1.append y=cn+i+g

' Performing a Static Solution
smpl 1960Q1 1999Q4
model1.solveopt(d=s)
model1.solve
'' Examining the Solution Results
model1.vars
model1.makegraph(a) fit_stat @endog

' Performing a Dynamic Solution
smpl 1985 1999
model1.solveopt(d=d)
model1.solve
model1.makegraph(a) fit_dynam @endog
'' Forecasting
''' Filling in Exogenous Data
smpl 1947 2005
equation g01.ls g c @trend
smpl 1960 1999
equation eqg.ls(arma=cls, optmethod=legacy) log(g) c @trend ar(1 to 4)
smpl 2000 2005
eqg.forecast(e, g) gf
series g = gf
series log(g_trend) = eqg.@coef(1) + eqg.@coef(2)*@trend
group govt g g_trend
smpl 1947 2005
graph gt.line govt
gt.axis log
gt.setelem(2) linepattern(dash6)

series m = @recode(@after("2000q1"), m(-1), m)
smpl 1960Q1 1999Q4
graph mt.line m
smpl 1995Q1 2005Q4
graph grph_m.line m
''' Producing Endogenous Forecasts
smpl 1995Q1 2005Q4
model1.solve
model1.makegraph frcst1 @endog
frcst1.draw(line, bottom, pattern(dash1)) 1999Q4

' Use Add Factors to Model Equation Residuals
series i_a = @recode(@after("2000q1"), 160, NA)
model1.addassign(i) i
smpl 2000 2005
model1.solve
model1.makegraph frcst2 @endog
frcst2.draw(line, bottom, pattern(dash1)) 1999Q4

' Performing a Stochastic Simulation
model1.solveopt(s=s)
model1.solve
smpl 1995 2005
model1.makegraph(a, s=s) frcst3 @endog

' Using Scenarios for Alternate Assumptions
model1.scenario "scenario 1"
model1.override m
series m_1 = @recode(@after("2000q1"), 900, m)
smpl 2000 2005
model1.solveopt(s=d)
model1.solve
smpl 1995q1 2005q4
model1.makegraph(c) frcst4 @endog
