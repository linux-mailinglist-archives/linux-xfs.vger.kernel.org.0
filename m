Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D033E3C17F
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 05:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390884AbfFKDTH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 23:19:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390856AbfFKDTH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 23:19:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5B3EDXI098034;
        Tue, 11 Jun 2019 03:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=WD/jtvyPKUSEaApZbB1Y5edzHeb4KFRIisH6xhFpx2I=;
 b=I8oMXdPF/Cwp+3sy79mu+Y/X0EmXf/TEyt0QidZ3A+yciMDKNMWj3FhRJi9fuGnkriKw
 H6q7MRe6/P097c2sMOJUUchJ9Yvqzozx6lugl7t7f7qNKDGS54Nw+JmLvurZG9vEVPBG
 VhsWLKAHFT2FZl4fJWKmXKRTV3eQM0x11aIipD5S8hDDEwVXtrYRApT4bQ71BmH7qV3+
 9zBiCKGrRfzSNwOr5fT1atMIGcK0apq5uyDB5K4fOQIanhnzSdpQXmpAd0Ze8xCqvc4E
 0LH2sSI/9UDuJk3m8QToDd6U4Tzr8pg2YIqATUzNLZ9/9MGqGYoU4brHOd19FAGmT9ML lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t04etjc7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 03:19:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5B3IArP006991;
        Tue, 11 Jun 2019 03:19:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t0p9r27w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 03:19:01 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5B3J0pH018038;
        Tue, 11 Jun 2019 03:19:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Jun 2019 20:18:59 -0700
Date:   Mon, 10 Jun 2019 20:18:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>, Dave Chinner <david@fromorbit.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/553: fix test description
Message-ID: <20190611031858.GG1688126@magnolia>
References: <20190610194545.8146-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610194545.8146-1-amir73il@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=946
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906110020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9284 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=998 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906110020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 10:45:45PM +0300, Amir Goldstein wrote:
> The test only checks copy to immutable file
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  tests/generic/553 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/553 b/tests/generic/553
> index efe25d84..117c0ad5 100755
> --- a/tests/generic/553
> +++ b/tests/generic/553
> @@ -4,7 +4,7 @@
>  #
>  # FS QA Test No. 553
>  #
> -# Check that we cannot copy_file_range() to/from an immutable file
> +# Check that we cannot copy_file_range() to an immutable file
>  #
>  seq=`basename $0`
>  seqres=$RESULT_DIR/$seq
> -- 
> 2.17.1
> 
