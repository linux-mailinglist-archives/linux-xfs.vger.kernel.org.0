Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7584416295C
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2020 16:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgBRPYg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Feb 2020 10:24:36 -0500
Received: from verein.lst.de ([213.95.11.211]:38714 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgBRPYg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Feb 2020 10:24:36 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 65CF868BE1; Tue, 18 Feb 2020 16:24:33 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:24:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/31] xfs: use strndup_user in
 XFS_IOC_ATTRMULTI_BY_HANDLE
Message-ID: <20200218152432.GB21275@lst.de>
References: <20200217125957.263434-1-hch@lst.de> <20200217125957.263434-6-hch@lst.de> <20200217221538.GJ10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217221538.GJ10776@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 18, 2020 at 09:15:39AM +1100, Dave Chinner wrote:
> >  
> > -		ops[i].am_error = strncpy_from_user((char *)attr_name,
> > -				ops[i].am_attrname, MAXNAMELEN);
> > -		if (ops[i].am_error == 0 || ops[i].am_error == MAXNAMELEN)
> > -			error = -ERANGE;
> > -		if (ops[i].am_error < 0)
> > +		attr_name = strndup_user(ops[i].am_attrname, MAXNAMELEN);
> > +		if (IS_ERR(attr_name)) {
> > +			ops[i].am_error = PTR_ERR(attr_name);
> >  			break;
> > +		}
> 
> This changes the error returned for an invalid attr name length from
> -ERANGE to either -EINVAL or -EFAULT. Can you please document that
> in the commit message. This change requires updates to the 
> path_to_handle(3) man page shipped in xfsprogs in the xfslibs-dev
> package (xfsprogs::man/man3/handle.3) to document the differences in
> return values.

I can't find that man page documenting -ERANGE at all..
