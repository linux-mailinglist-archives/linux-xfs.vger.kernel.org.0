Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56367355847
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Apr 2021 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhDFPko (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Apr 2021 11:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhDFPko (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 11:40:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3A6C06174A
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 08:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TX8sh2wIVqMDC/AEtjCilW8b55X1onJJfa6mheWTpZM=; b=BLLk4He1wxdmTS/RaUYA2L/h3v
        Du7nLlBA0OBw3CVcDDuiqLmv970DXXgMs2fqVipv9E1j/ZAdgb41qyS8+LtT3ijGWCvoN593F2X53
        bU7nyg0JcOB7btzL9kIXrEMlxWiGVedFlhzTG1iSW3kofEqioQsq0W/ZA3wxzOAgsRt6DUrTcPYop
        qlwW3hr1Zqtdvo/gayOKf3+BrlLlq5Plv46spIUnroDaq6OzfZce0z3qRr8xUHraSyJnLfGVklFJV
        c7WyRxAULZ4aLGNIwFxMq2RSio1F4Xti2Db7+QV4mmDSvCeQ8mI7Mp6+NsGxTV/36YC40nUGI3QZR
        2AHxgOBw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lTnoO-00D1p2-TB; Tue, 06 Apr 2021 15:40:21 +0000
Date:   Tue, 6 Apr 2021 16:40:16 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: eager inode attr fork init needs attr feature
 awareness
Message-ID: <20210406154016.GA3104374@infradead.org>
References: <20210406115923.1738753-1-david@fromorbit.com>
 <20210406115923.1738753-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406115923.1738753-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 06, 2021 at 09:59:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The pitfalls of regression testing on a machine without realising
> that selinux was disabled. Only set the attr fork during inode
> allocation if the attr feature bits are already set on the
> superblock.

This doesn't apply to the current xfs/for-next tree to me, with
rejects in xfs_default_attroffset.
