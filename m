Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9B43B9D5A
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Jul 2021 10:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhGBINp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Jul 2021 04:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGBINp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:13:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FD2C061762
        for <linux-xfs@vger.kernel.org>; Fri,  2 Jul 2021 01:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yhVxFenIgPub/w/35qpJsH+EleYVEBaF1uzR5/OHDEM=; b=Da51yCLYJF7F+3W/mqcV3PuVVJ
        d0da2p+6psI53dZadir4Aui8OPGfPKVubQUztcdfcXntrHTImyJM/nYveTOhnmgqkaPCSbrewpLsG
        kiumw133knC8BxIBHQ8ICBudimhOCC/LQaTIaHlSAmJm/j2QE8EdHoAviOwfu83tetbEPGHYHbIw2
        kw3sW73dC99uFBbBQsrFpx4N+3LWufNR1nHFc0tAAtdbezByh/gmHl+LjAPPBMsYy1V/2hj8FqvNP
        /upAG6AjUQy2dJNQRdIdbAb+TcmDhb9QupzUIU79RoESs70kSnQjh7sbM4bO41Wl39ZgJUxYd55tU
        leDOIE5w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzEFx-007U9E-GC; Fri, 02 Jul 2021 08:10:52 +0000
Date:   Fri, 2 Jul 2021 09:10:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: move recovery needed state updates to
 xfs_log_mount_finish
Message-ID: <YN7J/T5aHtsogxC6@infradead.org>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
