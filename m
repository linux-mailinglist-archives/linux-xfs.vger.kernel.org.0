Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76374315473
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 17:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhBIQyT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Feb 2021 11:54:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232959AbhBIQyG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 11:54:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2253A64DD6;
        Tue,  9 Feb 2021 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612889605;
        bh=fx/cVoIOIflJZzuNvVRgbZ/OYc+JjdG4XcrlTZ+vXhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZLedGDZMhnaifWIHbT/begOZ/h1wbwmtQwjT4+/l20iNrV/RzNc0ajGD/6X86+hiu
         3gbFc1/LC7+BhZqgu/iFGLnvZJxH429FpasQ8iHev2eMpwkCfEQfVNbYebO709bVn8
         LJmNCHIr6rCzytr4GLcuOqSel0SldIUhK277//NGd8WnnbBHLKOaQRkTueOWrZ9Oxo
         U2eHetUu7X7LUNxh88sirWY7JWIchUUhsFzXNhq7HNADDg40pX7r/BXr8mwtPAv/NA
         xA1oPdp5PD5ydlxedHe6p6clo3dOBnrN/OfpX3kRGT07tFRsSTyUad4Zx0o47/tW/j
         MAqLwgk2Q6TVA==
Date:   Tue, 9 Feb 2021 08:53:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 4/6] xfs_scrub: handle concurrent directory updates
 during name scan
Message-ID: <20210209165325.GF7190@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284389874.3058224.15020913005905277309.stgit@magnolia>
 <20210209093032.GP1718132@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209093032.GP1718132@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 09:30:32AM +0000, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 08:11:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
> > and the kernel does not provide a stable cursor interface, which means
> > that we can see the same byte sequence multiple times during a scan.
> > This isn't a confusing name error since the kernel enforces uniqueness
> > on the byte sequence, so all we need to do here is update the old entry.
> 
> So we get the same name but a different ino?  I guess that can happen
> with a replacing rename.  Maybe state that more clearly?

Ok, the paragraph now reads:

"The name scanner in xfs_scrub cannot lock a namespace (dirent or xattr)
and the kernel does not provide a stable cursor interface, which means
that we can see the same byte sequence multiple times during a scan if
other processes are performing replacing renames on the directory
simultaneously.  This isn't a confusing name error since the kernel
enforces uniqueness on the byte sequence, so all we need to do here is
update the old entry."

--D

> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
