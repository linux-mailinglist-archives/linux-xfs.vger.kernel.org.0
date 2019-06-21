Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1AA4ED1D
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 18:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfFUQZf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 12:25:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFUQZf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 12:25:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LGJnFo137731;
        Fri, 21 Jun 2019 16:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=QXZtjgnJF3LvYWYbAEJ122XsyPbedn8TODyBLNUo3IY=;
 b=UXPh6egvSLkuzoP7V1a+kwGV7uPpW5kNezGmQGKeLDg7f9tRXJVTfrVIs/1JxySdd+iq
 0LJxTck5oUnqZmSBRtgpzJXNsQbWJbyP+itkas7g5OLmhPBkbSFujei1HfUjPOk+Kx9q
 Y4DxvXDpHBQB5tNrJSyMT3uShj5SyoAByfLza3VLg5u012X3LARbaO9UHEs81/LBTR39
 suQzHgflK1aWdOIOHlx7o689om03bIzgu7WUH7a1KcMwjgXFdwaHMO4f1Gwgzi7ZpfZP
 Ms7AseqteJIPZT8C8feK4ebfrHqCCgGpY0fHwYdz8rAeSt39Ab9AiKyTpeQ+XaiFwkkK kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t7809qd54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 16:25:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LGOY5S091199;
        Fri, 21 Jun 2019 16:25:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t77yq1rwy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 16:25:31 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LGPUWN008254;
        Fri, 21 Jun 2019 16:25:30 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 09:25:29 -0700
Subject: Re: [PATCH 1/4] dump: _cleanup_dump should only check the scratch fs
 if the test required it
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
 <156089202883.345809.17656192140244878661.stgit@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <8194cb6e-4a29-5b18-e7be-fdb646dd8fe6@oracle.com>
Date:   Fri, 21 Jun 2019 09:25:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <156089202883.345809.17656192140244878661.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/18/19 2:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> _cleanup_dump always tries to check the scratch fs, even if the caller
> didn't actually _require_scratch.  If a previous test wrote garbage to
> the scratch device then the dump test will fail here when repair
> stumbles over the garbage.
> 
> This was observed by running xfs/016 and xfs/036 in succession.  xfs/016
> writes 0xc6 to the scratch device and tries to format a small log.  If
> the log is too small the format fails and the test will _notrun.  The
> subsequent xfs/036 will _notrun and then _cleanup_dump if no tape device
> is set, at which point we try to check the scratch device and logprint
> aborts due to the abnormal log size (0xc6c6c6c6).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks ok to me.
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
>   common/dump |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/common/dump b/common/dump
> index 7c4c9cd8..2b8e0893 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -250,7 +250,7 @@ _cleanup_dump()
>   	mv $dir.$seq $dir
>       done
>   
> -    if [ $status -ne $NOTRUNSTS ]; then
> +    if [ -f ${RESULT_DIR}/require_scratch ] && [ $status -ne $NOTRUNSTS ]; then
>   	# Sleep added to stop _check_scratch_fs from complaining that the
>   	# scratch_dev is still busy
>   	sleep 10
> 
