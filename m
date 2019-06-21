Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9434B4EF2A
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 21:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfFUTCM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 15:02:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46660 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfFUTCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:02:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LIwiV5157160;
        Fri, 21 Jun 2019 19:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=4sfqiOfr0Gfp+6LzV5xL8I0gcOGQYyUv5VGVV2RDboU=;
 b=zO5CHrVibGdTXk6Yt0mwPDoMmS/YrPfe9bWcI1DubN435LVrnLny10iXPuvM78TGlTef
 kFCj/zjiO7WNjxxa9tbAHiyEJT1Rny/v837D13Dhm5HuIHWP/yFIf/1jE3c2cOiEcoU2
 vQJWSymSUIa8aGpJz4jGep1wYyBFJHSN4CicMYJaJMkd5j+/3CYgJnRjXIQe0nliMKDS
 plMKvPrzOqHSWH6+YLOwhjQTPGNVNg4DJ7GpcDnPVqN6olCCyiYu6+3gIKKw0KthQY5Y
 /RjFEORZ7qxxcUzj8yVvPFYcbC3C2Yr3w9/Cohq6HnmA3lWRfBkMruilWK8X3y/ZmI+P 8g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t7809qyxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:02:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJ0ZAL055950;
        Fri, 21 Jun 2019 19:02:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t77yq3uwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:02:09 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LJ28GA019914;
        Fri, 21 Jun 2019 19:02:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 12:02:07 -0700
Date:   Fri, 21 Jun 2019 12:02:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: rework min log size helper
Message-ID: <20190621190206.GC5380@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089203509.345809.3448903728041546348.stgit@magnolia>
 <20190621085748.GH15846@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621085748.GH15846@desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 04:57:48PM +0800, Eryu Guan wrote:
> On Tue, Jun 18, 2019 at 02:07:15PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The recent _scratch_find_xfs_min_logblocks helper has a major thinko in
> > it -- it relies on feeding a too-small size to _scratch_do_mkfs so that
> > mkfs will tell us the minimum log size.  Unfortunately, _scratch_do_mkfs
> > will see that first failure and retry the mkfs without MKFS_OPTIONS,
> > which means that we return the minimum log size for the default mkfs
> > settings without MKFS_OPTIONS.
> > 
> > This is a problem if someone's running fstests with a set of
> > MKFS_OPTIONS that affects the minimum log size.  To fix this, open-code
> > the _scratch_do_mkfs retry behavior so that we only do the "retry
> > without MKFS_OPTIONS" behavior if the mkfs failed for a reason other
> > than the minimum log size check.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/rc  |   13 ++++++++++---
> >  common/xfs |   23 +++++++++++++++++++++--
> >  2 files changed, 31 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 25203bb4..a38b7f02 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -438,6 +438,14 @@ _scratch_mkfs_options()
> >      echo $SCRATCH_OPTIONS $MKFS_OPTIONS $* $SCRATCH_DEV
> >  }
> >  
> > +# Format the scratch device directly.  First argument is the mkfs command.
> > +# Second argument are all the parameters.  stdout goes to $tmp.mkfsstd and
> > +# stderr goes to $tmp.mkfserr.
> > +__scratch_do_mkfs()
> > +{
> > +	eval "$1 $2 $SCRATCH_DEV" 2>$tmp.mkfserr 1>$tmp.mkfsstd
> 
> I'd prefer leaving stdout and stderr to caller to handle, because ..
> 
> 
> > +}
> > +
> >  # Do the actual mkfs work on SCRATCH_DEV. Firstly mkfs with both MKFS_OPTIONS
> >  # and user specified mkfs options, if that fails (due to conflicts between mkfs
> >  # options), do a second mkfs with only user provided mkfs options.
> > @@ -456,8 +464,7 @@ _scratch_do_mkfs()
> >  
> >  	# save mkfs output in case conflict means we need to run again.
> >  	# only the output for the mkfs that applies should be shown
> > -	eval "$mkfs_cmd $MKFS_OPTIONS $extra_mkfs_options $SCRATCH_DEV" \
> > -		2>$tmp.mkfserr 1>$tmp.mkfsstd
> 
> it's easier to know the $tmp.mkfserr and $tmp.mkfsstd files should be
> cleaned up, otherwise it's not that clear where these files come from.
> 
> > +	__scratch_do_mkfs "$mkfs_cmd" "$MKFS_OPTIONS $extra_mkfs_options"
> >  	mkfs_status=$?
> >  
> >  	# a mkfs failure may be caused by conflicts between $MKFS_OPTIONS and
> > @@ -471,7 +478,7 @@ _scratch_do_mkfs()
> >  		) >> $seqres.full
> >  
> >  		# running mkfs again. overwrite previous mkfs output files
> > -		eval "$mkfs_cmd $extra_mkfs_options $SCRATCH_DEV" \
> > +		__scratch_do_mkfs "$mkfs_cmd" "$extra_mkfs_options" \
> >  			2>$tmp.mkfserr 1>$tmp.mkfsstd
> 
> With the implemention in the patch, the "2>$tmp.mkfserr 1>$tmp.mkfsstd"
> part should be removed too, but with the suggested implemention we can
> keep it :)

Ok, will change this.

> >  		mkfs_status=$?
> >  	fi
> > diff --git a/common/xfs b/common/xfs
> > index f8dafc6c..8733e2ae 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -87,16 +87,33 @@ _scratch_find_xfs_min_logblocks()
> >  	# minimum log size.
> >  	local XFS_MIN_LOG_BYTES=2097152
> >  
> > -	_scratch_do_mkfs "$mkfs_cmd" "cat" $* -N -l size=$XFS_MIN_LOG_BYTES \
> > -		2>$tmp.mkfserr 1>$tmp.mkfsstd
> > +	# Try formatting the filesystem with all the options given and the
> > +	# minimum log size.  We hope either that this succeeds or that mkfs
> > +	# tells us the required minimum log size for the feature set.
> > +	#
> > +	# We cannot use _scratch_do_mkfs because it will retry /any/ failed
> > +	# mkfs with MKFS_OPTIONS removed even if the only "failure" was that
> > +	# the log was too small.
> > +	local extra_mkfs_options="$* -N -l size=$XFS_MIN_LOG_BYTES"
> > +	__scratch_do_mkfs "$mkfs_cmd" "$MKFS_OPTIONS $extra_mkfs_options"
> >  	local mkfs_status=$?
> >  
> > +	# If the format fails for a reason other than the log being too small,
> > +	# try again without MKFS_OPTIONS because that's what _scratch_do_mkfs
> > +	# will do if we pass in the log size option.
> > +	if [ $mkfs_status -ne 0 ] &&
> > +	   ! grep -q 'log size.*too small, minimum' $tmp.mkfserr; then
> > +		__scratch_do_mkfs "$mkfs_cmd" "$extra_mkfs_options"
> > +		local mkfs_status=$?
> 
> We've already declared mkfs_status as local, no need to do it again
> here.

Will fix.

--D

> Thanks,
> Eryu
> 
> > +	fi
> > +
> >  	# mkfs suceeded, so we must pick out the log block size to do the
> >  	# unit conversion
> >  	if [ $mkfs_status -eq 0 ]; then
> >  		local blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
> >  			sed -e 's/log.*bsize=\([0-9]*\).*$/\1/g')"
> >  		echo $((XFS_MIN_LOG_BYTES / blksz))
> > +		rm -f $tmp.mkfsstd $tmp.mkfserr
> >  		return
> >  	fi
> >  
> > @@ -104,6 +121,7 @@ _scratch_find_xfs_min_logblocks()
> >  	if grep -q 'minimum size is' $tmp.mkfserr; then
> >  		grep 'minimum size is' $tmp.mkfserr | \
> >  			sed -e 's/^.*minimum size is \([0-9]*\) blocks/\1/g'
> > +		rm -f $tmp.mkfsstd $tmp.mkfserr
> >  		return
> >  	fi
> >  
> > @@ -111,6 +129,7 @@ _scratch_find_xfs_min_logblocks()
> >  	echo "Cannot determine minimum log size" >&2
> >  	cat $tmp.mkfsstd >> $seqres.full
> >  	cat $tmp.mkfserr >> $seqres.full
> > +	rm -f $tmp.mkfsstd $tmp.mkfserr
> >  }
> >  
> >  _scratch_mkfs_xfs()
> > 
