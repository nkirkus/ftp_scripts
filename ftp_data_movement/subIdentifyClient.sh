#!/bin/bash test
#
# Identify client name by looking at the username the file belongs to. Echo results.
#

file=$(basename "$1")
username=`stat -c %U "$1"`

if [ "$username" == testftp ];
	then
		clientname="TestFTP"
elif [ "$username" == root ];
	then
		clientname="UnknownUser"

elif [ "$username" == fulfillmentftp1 ];
	then
		clientname="UnknownUser"

elif [ "$username" == averittftp ];
	then
		clientname="AverittExpress"

elif [ "$username" == averittexpressscriptsftp ];
        then
                clientname="AverittExpress"

elif [ "$username" == averittbcbsftp ];
        then
                clientname="AverittExpress"

elif [ "$username" == belmontftp ];
	then
		clientname="zArchive\Belmont"

elif [ "$username" == comdataftp ];
	then
		clientname="Comdata"

elif [ "$username" == hsftp ];
	then
		clientname="HealthSpringSaaS"

elif [ "$username" == iasisftp ];
	then
		clientname="Iasis"

elif [ "$username" == iasiscowanftp ];
    then
        clientname="Iasis"

elif [ "$username" == iasisaltiusftp ];
        then
                clientname="Iasis"

elif [ "$username" == iasiscaremarkftp ];
        then
                clientname="Iasis"

elif  [ "$username" == ingramftp ];
	then
		clientname="Ingram"
elif [ "$username" == ingramcaremarkftp ];
	then
		clientname="Ingram"
elif [ "$username" == ingrambcbsftp ];
        then
                clientname="Ingram"

elif [ "$username" == rxsolftp ];
	then
		clientname="RxSolutions"
		dl="RxSolutionsFTPAlert@pharmmd.com"
elif [ "$username" == amedysisftp ];
	then
		clientname="Amedysis"

elif [ "$username" == pmduser ];
	then
		clientname="UnknownUser"
elif [ "$username" == brookdalecarehereftp ];
	then
		clientname="Brookdale"
elif [ "$username" == sencareftp ];
	then
		clientname="SeniorCare"
elif [ "$username" == brookdaleftp ];
	then
		clientname="Brookdale"
elif [ "$username" == walgreensftp ];
	then
		clientname="Brookdale"
elif [ "$username" == hcaftp ];
	then
		clientname="HealthChoice"
elif [ "$username" == healthwaysftp ];
        then
                clientname="AverittExpress"
elif [ "$username" == hibbettftp ];
        then
                clientname="Hibbett"
elif [ "$username" == arcadianftp ];
        then
                clientname="Arcadian"
		dl="ArcadianFTPAlert@pharmmd.com"
elif [ "$username" == scanhealthftp ];
        then
		if [ `echo "$file" | grep -i "test_" | wc -l` == 1 ]
		then
			clientname="_ClientFiles_y\SCAN"
		else
			clientname="SCAN"
			dl="PharmMD_Support@scanhealthplan.com"
		fi
elif [ "$username" == emdeonftp ];
        then
                clientname="CMI"
		dl="Steve.Miller@pharmmd.com,ccampbell@emdeon.com"
elif [ "$username" == cmiftp ];
	then
		clientname="CMI"
		dl="Steve.Miller@pharmmd.com,CMIFTPAlert@pharmmd.com"
elif [ "$username" == anthemftp ];
	then
		clientname="SeniorCare"
elif [ "$username" == benfocftp ];
	then
		clientname="SeniorCare"
		dl="elinksSupport@benefitfocus.com"
elif [ "$username" == uhcftp ];
        then
                clientname="Brookdale"
elif [ "$username" == anthemctftp ];
        then
                clientname="SaintRaphael"
elif [ "$username" == stvincentftp ];
        then
                clientname="SaintVincent"
elif [ "$username" == bcbsneftp ];
        then
                clientname="ConAgra"
elif [ "$username" == centineftp ];
	then
		clientname="Centene"
elif [ "$username" == centeneftp ];
	then
		clientname="Centene"
elif [ "$username" == amerigroupftp  ];
	then
		clientname="zProspect\Amerigroup"
elif [ "$username" == humanaftp ];
	then
		clientname="Humana"
elif [ "$username" == bgorrieftp ];
        then
                clientname="BrasfieldGorrie"
elif [ "$username" == bgcensusftp ];
        then
                clientname="BrasfieldGorrie"
elif [ "$username" == colonialftp ];
        then
                clientname="ColonialProperties"
elif [ "$username" == vitasftp ];
        then
                clientname="VITAS"
elif [ "$username" == vivahealthftp ];
        then
                clientname="VIVAHealth"
elif [ "$username" == vnsnyftp ];
        then
                clientname="VNSNY"
elif [ "$username" == ivhpftp ];
        then
                clientname="IVHP"
elif [ "$username" == sxcftp ];
        then
                clientname="SXC"
elif [ "$username" == archftp ];
	then
		clientname="zProspect\Gallagher"
elif [ "$username" == GABankers ];
    then
        clientname="GABankers"
elif [ "$username" == ebscoftp ];
    then
        clientname="EBSCO"

elif [ "$username" == hcacaremarkftp ];
    then
        clientname="HCA"
elif [ "$username" == hcaaetnaftp ];
    then
        clientname="HCA"
elif [ "$username" == hcaxeroxftp ];
    then
        clientname="HCA"
elif [ "$username" == partnersrxftp ];
    then
        clientname="GABankers"
elif [ "$username" == aocanthemftp ];
    then
        clientname="AoC"
elif [ "$username" == aocbasftp ];
    then
        clientname="AoC"
elif [ "$username" == aocoptumftp ];
    then
        clientname="AoC"
elif [ "$username" == healthspringal ];
    then
        clientname="HealthSpringAL"
elif [ "$username" == ttractorftp ];
    then
        clientname="ThompsonTractor"
elif [ "$username" == stvmedimpactftp ];
    then
		clientname="SaintVincent"
elif [ "$username" == corizon ];
    then
        clientname="Corizon"
elif [ "$username" == lovelaceftp ];
    then
        clientname="Lovelace"
elif [ "$username" == marathonaverittftp ]
	then
		clientname="AverittExpress"
elif [ "$username" == elderplanftp ]
    then
        clientname="Elderplan"
elif [ "$username" == meddecisionsftp ]
    then
        clientname="Medecision"
elif [ "$username" == medecisionftp ]
    then
        clientname="Medecision"
else
        clientname="UnknownUser"
fi


# If client file is from hsftp look at the filename to set the proper clientname.

if [ "$username" == "hsftp" ];
        then
                if [ `echo "$file" | grep -e SXCPCTSTD -e SXCPCTMED -e HM11000__hm11001i | wc -l` == 1 ];
                then
                        clientname="HealthSpringAL"
                else
                        clientname="HealthSpringSaaS"
			dl="jeff.tunney@healthspring.com"
		fi
fi

# If client file is from uhc look at the filename to set the proper clientname.

if [ "$username" == "uhcftp" ];
then
	{
			clientname="Corizon"
	}
elif [ "$username" == "carehereftp" ];
	then {
		if [ `echo "$file" | grep "Brookdale" | wc -l` == 1 ];
		then
			clientname="Brookdale"
		elif [ `echo "$file" | grep "Calsonic" | wc -l` == 1 ];
		then
			clientname="Calsonic"
		else
			"UnknownUser"
		fi
	}
fi

if [ $2 ]
then
if [ $2 == "getDL" ]
then
	echo "$dl"
else
	echo "$clientname"
fi
else
	echo "$clientname"
fi
