#!/bin/bash

userip=$(printenv IP_AREA)
tomas="IP_AREA="
bill="BILLIP="
if [ -z "$userip" ]
then
    userip=$bill$(printenv BILLIP)
else
    userip=$tomas$userip
fi
echo "$userip" > .env
cat .env