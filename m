Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED05B24E
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 01:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfF3XLj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Jun 2019 19:11:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfF3XLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 19:11:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5UN9v6u066248;
        Sun, 30 Jun 2019 23:11:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=ToxWtqacVfownbbDFFcde5FMgsORBrZOHnuANCbJNqc=;
 b=V0zjCQI7uEgDCnl8P4y7Ql+LZjD0e7u0vNIWNoJh5lWC/XRhAXV5sbZUNpx8T7FH0+EH
 +bUbTjQZAG+SZtuLVbb9r6AuEXWMGlSnlLQsWjoAMJxyZW/tmsPWlU05bCwkDFilH18C
 grrn+9HoRt+u+tkHzzEmQULAMoQ2/sKKwsbP/NsLgcyS+ZPZkiLgE4/CLj99yCFLkcED
 okkzZS4CPYxEKk7fwvpFGyqYjlnypBjLMHglwbSgwCvW8W3SK9etRGgh77ihQvaNZd7z
 kEzFUP8QljafCmOFt5y48PO9TG9EQHwh8qZ84vnZUJ3+EyC218dAGBZp7N3oSaj3wnOx jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tbakhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Jun 2019 23:11:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5UN7SiB116455;
        Sun, 30 Jun 2019 23:11:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tebqfnfu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 30 Jun 2019 23:11:32 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5UNBUAs016678;
        Sun, 30 Jun 2019 23:11:31 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Jun 2019 16:11:30 -0700
Date:   Sun, 30 Jun 2019 16:11:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Include 'xfs: speed up large directory modifications' in 5.3?
Message-ID: <20190630231130.GA1654093@magnolia>
References: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
 <20190630153955.GF1404256@magnolia>
 <20190630223605.GK7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190630223605.GK7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9304 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906300298
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9304 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906300298
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 01, 2019 at 08:36:05AM +1000, Dave Chinner wrote:
> On Sun, Jun 30, 2019 at 08:39:55AM -0700, Darrick J. Wong wrote:
> > On Sun, Jun 30, 2019 at 01:28:09PM +0200, Holger Hoffstätte wrote:
> > > Hi,
> > > 
> > > I have been running with Dave's series for faster directory inserts since
> > > forever without any issues, and the last revision [1] still applies cleanly
> > > to current5.2-rc (not sure about xfs-next though).
> > > Any chance this can be included in 5.3? IMHO it would be a shame if this
> > > fell through the cracks again.
> > > 
> > > Thanks,
> > > Holger
> > > 
> > > [1] https://patchwork.kernel.org/project/xfs/list/?series=34713
> > 
> > Christoph reviewed most of the series, but it looked like he and Dave
> > went back and forth a bit on the second to last patch and Dave never
> > sent a v2 series or a request to just merge it as is, so I didn't take
> > any action.  Hey Dave, are you still working on a resubmission for this
> > series?
> 
> It's in my stack somewhere. Not for this cycle. Can't even remember
> what was the issue with it.  I'm pretty sure that was about when the
> whole copy file range debacle exploded in our faces, which was why
> there was no followup back then...

I vague recollection is that I looked at it and remember thinking it was
fine except maybe for the tweaks hch suggested, and then copyfilerange
blew up and that was it, everything got derailed. :(

/me shakes fist at crAPIs....

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
