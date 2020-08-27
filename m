Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31AD254984
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Aug 2020 17:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgH0Pd0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Aug 2020 11:33:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgH0Pd0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Aug 2020 11:33:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RFSpi5025917;
        Thu, 27 Aug 2020 15:33:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=wTv+sWvHV0KzfyteQtYj7vZ1y+bPyQyW08HcNPThAAY=;
 b=HW/tQtCGi7QMKPAvJvMqs97diTzUWNynzeNq6f2rdw3ywb2Dgs2AHTmsCJly2Ggk1oMu
 cKl+bwZgC6dWhi6WfjnCWqH+ipSVyVtXDB9HUpoIwRFKRIBI3zofSP3eEBGYHdtdhGDa
 z0WPRS0k0YUi0H2Fqgeow4ZAmziZj4mxLAFiYXb/Pp/4in1bTU3tgelhjMF2k2KfWP0+
 Zeu2A8NWqog3FJxL8oxADvZTRgA0fWKJJh97zS2dvrh/HROib1mwQuVqUdXMD2wR9CYk
 AFUwraYB5bGGUDjluSbtsiBPsnbv85ItN3T8B941tmn2x67dl7ousWXy+G14nlXgv4Mn Cw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 335gw88x4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Aug 2020 15:33:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07RFUfp3047676;
        Thu, 27 Aug 2020 15:31:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 333ruda7xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 15:31:09 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07RFV8uM005643;
        Thu, 27 Aug 2020 15:31:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Aug 2020 08:31:08 -0700
Date:   Thu, 27 Aug 2020 08:31:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     david@fromorbit.com, linux-xfs@vger.kernel.org, amir73il@gmail.com,
        sandeen@sandeen.net
Subject: Re: [PATCH 07/11] xfs: kill struct xfs_ictimestamp
Message-ID: <20200827153107.GT6096@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
 <159847954327.2601708.9783406435973854389.stgit@magnolia>
 <20200827065114.GA17534@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827065114.GA17534@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=1 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9726 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270116
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 07:51:14AM +0100, Christoph Hellwig wrote:
> > + */
> > +static inline xfs_ictimestamp_t
> > +xfs_inode_to_log_dinode_ts(
> > +	const struct timespec64	tv)
> > +{
> > +	uint64_t		t;
> > +
> > +#ifdef __LITTLE_ENDIAN
> > +	t = ((uint64_t)tv.tv_nsec << 32) | ((uint64_t)tv.tv_sec & 0xffffffff);
> > +#elif __BIG_ENDIAN
> > +	t = ((int64_t)tv.tv_sec << 32) | ((uint64_t)tv.tv_nsec & 0xffffffff);
> > +#else
> > +# error System is neither little nor big endian?
> > +#endif
> > +	return t;
> 
> Looking at this I wonder if we should just keep the struct and cast
> to it locally in the conversion functions, as that should take
> care of everything.  Or just keep the union from the previous version,
> sorry..

Yeah, thinking about this ugliness some more I think I'd rather just use
a pointer cast here since the ifdef stuff is gross.

--D
