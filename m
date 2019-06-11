Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F20F3C180
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 05:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390894AbfFKDT3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 23:19:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50586 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390856AbfFKDT3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 23:19:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5B3JOw3111303;
        Tue, 11 Jun 2019 03:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=ZOgHarOxF2hEPoyRCnPV7DlgtQgOjXBpTgQFdPUxQIo=;
 b=E4zpRRzamxAPUvCrZEyiQs7FM2MQ9vBiEqVOSF3J5jKc5mP6srqNqjJuHpnLeM1YcYe0
 V1v6UGsSvCrv478u8aWZucA2LqFkXUd0iTOg1uxh5TkC6JdXI2YwxjQzahDFnX6qA0SJ
 wMNfE7M1y9DBpYMeN4I8xYcnYkEHSBLwY1QqbYI2IjEPB44deaiVlOhLRcXkNk95ExiP
 qL6lLTkrsPWHzTistmflHr1t1LORnB4DyAG68Pe1mWjyp+GpdXksBo4Uka5WtUSRbNn7
 uVN+iWeerbAYiRBX+OlkBbr1w5lcVYL1eL6z3/cxP+MqCvpHpRwtKa+yEFyJ3yutQTBw 4A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t05nqj9jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 03:19:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5B3JG0J005186;
        Tue, 11 Jun 2019 03:19:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2t024u5qdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 03:19:20 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5B3JJJ0009822;
        Tue, 11 Jun 2019 03:19:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 20:19:19 -0700
Date:   Mon, 10 Jun 2019 20:19:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/554: test only copy to active swap file
Message-ID: <20190611031917.GH1688126@magnolia>
References: <20190610195317.8516-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610195317.8516-1-amir73il@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906110020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906110021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 10:53:17PM +0300, Amir Goldstein wrote:
> Depending on filesystem, copying from active swapfile may be allowed,
> just as read from swapfile may be allowed.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

LGTM,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Eryu,
> 
> Following feedback by Ted, I've decided it would be better to
> remove the test case of copy from swap file.
> There is no reason to deny that copy, but there is also no reason
> for us to assert that filesystems must allow this functionality.
> 
> Even after removing the copy from test case, test still fails
> on upstream for all filesystems I tested.
> Tests passes with Darrick's copy-file-range-fixes branch.
> 
> Thanks,
> Amir.
> 
>  tests/generic/554     | 3 +--
>  tests/generic/554.out | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/tests/generic/554 b/tests/generic/554
> index 10ae4035..c946ca17 100755
> --- a/tests/generic/554
> +++ b/tests/generic/554
> @@ -4,7 +4,7 @@
>  #
>  # FS QA Test No. 554
>  #
> -# Check that we cannot copy_file_range() to/from a swapfile
> +# Check that we cannot copy_file_range() to a swapfile
>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> @@ -46,7 +46,6 @@ echo swap files return ETXTBUSY
>  _format_swapfile $SCRATCH_MNT/swapfile 16m
>  swapon $SCRATCH_MNT/swapfile
>  $XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/file" $SCRATCH_MNT/swapfile
> -$XFS_IO_PROG -f -c "copy_range -l 32k $SCRATCH_MNT/swapfile" $SCRATCH_MNT/copy
>  swapoff $SCRATCH_MNT/swapfile
>  
>  # success, all done
> diff --git a/tests/generic/554.out b/tests/generic/554.out
> index ffaa7b0a..19385a05 100644
> --- a/tests/generic/554.out
> +++ b/tests/generic/554.out
> @@ -1,4 +1,3 @@
>  QA output created by 554
>  swap files return ETXTBUSY
>  copy_range: Text file busy
> -copy_range: Text file busy
> -- 
> 2.17.1
> 
