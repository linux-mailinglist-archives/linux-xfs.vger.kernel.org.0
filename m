Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C159A8D745
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Aug 2019 17:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfHNPgN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Aug 2019 11:36:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42804 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNPgN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 11:36:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EFYIVa192842;
        Wed, 14 Aug 2019 15:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=AcYAwpDAlV3lEqm8EPFpKG3A+HdUPnkVFzl46IX8meg=;
 b=gIgwMEutqRR0mkXERsCOsBKpj0LVfxXNWht7NFSJVWd0ZS+M6VNGysgbrgyU0Xi8TOkQ
 2sCt6cjGTU05TmesAl509FOd1dtj2sMfSAInmUdp8JpseTZyS58iGPwAEHQp3fI7KIs8
 Gju0g9QyrDNHZRYpUYBr3pC+5/MlfCPwTbJN7E3cHCdXPPE8i3SfY0pSIoHrBJlkCH4e
 kPC5BvHGhCBCC+nLVbHT3VhjszUMedzbZsuXBirfbUgI/RZtv9DkE4Y/ZT2Ka9iP/nVi
 SVfgzXHLiYG/r9Y7aylsIlr0jGa/MaJgChnyfmoQA580+UN7RuyWXnbBmIvDQW6Kpt5V 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvpdqhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 15:36:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EFXhsP178732;
        Wed, 14 Aug 2019 15:36:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2ucgeyuq9q-33
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 15:36:10 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7EFIklT018319;
        Wed, 14 Aug 2019 15:18:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 08:18:45 -0700
Date:   Wed, 14 Aug 2019 08:18:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: use cvtnum from libfrog
Message-ID: <20190814151844.GR7138@magnolia>
References: <20190813051421.21137-1-david@fromorbit.com>
 <20190813051421.21137-2-david@fromorbit.com>
 <20190813142414.GO7138@magnolia>
 <20190813212936.GF6129@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813212936.GF6129@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=949
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908140153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908140153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 07:29:36AM +1000, Dave Chinner wrote:
> On Tue, Aug 13, 2019 at 07:24:14AM -0700, Darrick J. Wong wrote:
> > On Tue, Aug 13, 2019 at 03:14:19PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > -	}
> > > -	if (*sp == 's') {
> > > -		if (!sectsize) {
> > > -			fprintf(stderr,
> > > -_("Sectorsize must be specified prior to using 's' suffix.\n"));
> > 
> > Hmm, so this message is replaced with "Not a valid value or illegal suffix"?
> 
> Actually, the error message is this:
> 
> # mkfs.xfs -f -b size=1b /dev/vdc
> Invalid value 1b for -b size option. Not a valid value or illegal suffix
> 
> It does actually tell you what the value is, what option is wrong,
> and the message shold be fairly clear that specifying the block size
> in using a "blocks" suffix is illegal.
> 
> > That's not anywhere near as helpful as the old message... maybe we
> > should have this set errno or something so that callers can distinguish
> > between "you sent garbled input" vs. "you need to set up
> > blocksize /sectsize"... ?
> 
> Actually, the error will only occur when you use -s size= or -b
> size= options, as if they are not specified we use the default
> values in mkfs and cvtnum is always called with a valid
> blocksize/sectorsize pair. i.e. This error only triggers when validating
> the base sector size/block size options because that occurs before
> we set the global varibles mkfs will use for cvtnum....
> 
> It's a chicken-egg thing, and I figured the error message prefix
> would be sufficient to point out the problem with the value suffic
> used for these kinda unusual corner cases.

Heh, ok, carry on then. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
