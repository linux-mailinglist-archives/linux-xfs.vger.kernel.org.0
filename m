Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB8D5BDDD
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jul 2019 16:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfGAOOi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jul 2019 10:14:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43626 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbfGAOOi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 10:14:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61EE6Kw059564;
        Mon, 1 Jul 2019 14:14:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=fbnqRpE5+2pU9s0oZ3nl0lcV4p/Ctz2QNkmT4a/2jAU=;
 b=wl87EhXZPXk/0HeEvvvEFJ1RkLsH+hhpYvTkUAWb70o3imZeU0YXmfVHBTBNMbo0s5S5
 EJSTKVYhi6z5mag8SqH5nxfIjHZ778lA5fnFK3FhljOHAjHQgXVoqbmNpowZbnb9G2b9
 zdpLy7PvHsnGLX7SfTJ6hYHHDZSOs4eJIFG1wMKuD5Kd9iQn1RKABtcVlJBm1bF5U2uA
 C5PiA161OF2r88EbhtW4wUcUy7FKftHLT/Yy4MASKzG4kd2pyO4p9o8SJi5qYv6xhgyr
 JeGUIw8HB6lO2oK0O2UYlZYaL/rzKOwcUsc6aM2IhxQyf8lsiCLlJ6lXKvFniJ8XsFwI kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2te61pnx04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 14:14:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61EDGWD188170;
        Mon, 1 Jul 2019 14:14:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tebbj6sv3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 14:14:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61EEWe8002996;
        Mon, 1 Jul 2019 14:14:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 07:14:32 -0700
Date:   Mon, 1 Jul 2019 07:14:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] mkfs: use libxfs to write out new AGs
Message-ID: <20190701141432.GB1654093@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114705924.1643538.6635085530435538461.stgit@magnolia>
 <20190701122504.GM7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701122504.GM7777@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=968
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 01, 2019 at 10:25:04PM +1000, Dave Chinner wrote:
> On Fri, Jun 21, 2019 at 12:57:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Use the libxfs AG initialization functions to write out the new
> > filesystem instead of open-coding everything.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > @@ -4087,8 +3770,16 @@ main(
> >  	/*
> >  	 * Initialise all the static on disk metadata.
> >  	 */
> > +	INIT_LIST_HEAD(&buffer_list);
> >  	for (agno = 0; agno < cfg.agcount; agno++)
> > -		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist);
> > +		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist,
> > +				&buffer_list);
> > +
> > +	if (libxfs_buf_delwri_submit(&buffer_list)) {
> > +		fprintf(stderr, _("%s: writing AG headers failed\n"),
> > +				progname);
> > +		exit(1);
> > +	}
> 
> The problem I came across with this "one big delwri list" construct
> when adding delwri lists for batched AIO processing is that the
> memory footprint for high AG count filesystems really blows out. Did
> you check what happens when you create a filesystem with a few tens
> of thousands of AGs? 

I did, and then amended this patch to delwri_submit every ~16 or so AGs.

:)

I haven't resent the patch since I figure xfsprogs 5.3 is a ways off...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
