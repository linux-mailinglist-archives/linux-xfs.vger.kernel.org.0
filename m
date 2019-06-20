Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6194DAD4
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 21:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfFTT52 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 15:57:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfFTT52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 15:57:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KJn8LT011536;
        Thu, 20 Jun 2019 19:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=zkbXDuu4mYGj0v4A9vGiXyOkoDOZqJLRomNs/vMCJ30=;
 b=opGeBJ484Y0rvhAA+i1lpKQfGc2voxFy60BRFRzAkDdC6A93nTMl8yBLAHNh1PDVyT4P
 ktVLUrSnbsVdwoXaqJ5ymQnMrs0BNGMmmX+7tIHC6wep/odx3xCjzl6dATeINTXo3WtR
 vsQS50LoAXR98HKyM3gXhKBXrJ41zsnFpHJ5tJ8xP48gDn31MevFTpZtnj/3G8T3Orf/
 p8yKbCMWK2OogqdtSqLobCx5M4QqAHl2k0ZBiqyeXkKaO/lYC/Kjzvkt3ngVyg5AdvYY
 Z559MTYjw0hMV3obce8KT/AUaOX6UryoCckXMWTbKRpsF4SAMSVMfJrUxrlVgf27RWCk ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t7809k1vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 19:57:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KJtitt119217;
        Thu, 20 Jun 2019 19:57:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2t77yntcnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jun 2019 19:57:24 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KJvNE3026529;
        Thu, 20 Jun 2019 19:57:23 GMT
Received: from localhost (/10.145.179.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 12:57:23 -0700
Date:   Thu, 20 Jun 2019 12:57:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/12] libxfs-diff: try harder to find the kernel
 equivalent libxfs files
Message-ID: <20190620195722.GD5402@magnolia>
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104944022.1172531.15814499652713220817.stgit@magnolia>
 <2721bbee-5ff4-4016-f18a-5008e86ad4ab@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2721bbee-5ff4-4016-f18a-5008e86ad4ab@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200141
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 20, 2019 at 02:53:14PM -0500, Eric Sandeen wrote:
> On 6/20/19 11:50 AM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we're syncing userspace libxfs/ files with kernel fs/xfs/
> > files, teach the diff tool to try fs/xfs/xfs_foo.c if
> > fs/xfs/libxfs/xfs_foo.c doesn't exist.
> 
> do we really need this or should I just send a patch for the kernel
> to move it?

Nah just send a kernel patch.

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tools/libxfs-diff |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > 
> > diff --git a/tools/libxfs-diff b/tools/libxfs-diff
> > index fa57c004..c18ad487 100755
> > --- a/tools/libxfs-diff
> > +++ b/tools/libxfs-diff
> > @@ -22,5 +22,6 @@ dir="$(readlink -m "${dir}/..")"
> >  
> >  for i in libxfs/xfs*.[ch]; do
> >  	kfile="${dir}/$i"
> > +	test -f "${kfile}" || kfile="$(echo "${kfile}" | sed -e 's|libxfs/||g')"
> >  	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
> >  done
> > 
