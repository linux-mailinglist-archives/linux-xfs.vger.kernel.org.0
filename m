Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA3F1DF63A
	for <lists+linux-xfs@lfdr.de>; Sat, 23 May 2020 11:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387678AbgEWJTD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 May 2020 05:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387498AbgEWJTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 05:19:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB62C061A0E
        for <linux-xfs@vger.kernel.org>; Sat, 23 May 2020 02:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e18HrB6eW5qaSUCZc+GmBpaowa4StiDJ9zGroyzyKfo=; b=TP50jznlBduUp+GqGAIJeSQyVU
        01w9b1rcfx3BSmPnNsh2ynLglwRNSxyU8UgVBg64kRrIIoOYoQU6nULzv91cuQCveiv166vyiy51i
        AWIBRMMkMEQs/SVwmhJWD5GBVQnztJj+KudjpV58oV/rxBcT6etgt2p1JgGnBpuRl4gLG+7ss/qjY
        zKYhNQQt6IJdNCUuj7YQH8/R0HKuzeEmJCxZHUQizCdp7XzDJDm3V6nJ6eC5p37w0vcD6zleKX8VX
        jki546Gb1wWxeAEeeAyiseOABX4sVRQIpNy/P8yQ7LmNKKKLUfNcKmNeu95V9ELyqHID4wE5a7R+i
        Izi72/TA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcQJ4-00023S-L7; Sat, 23 May 2020 09:19:02 +0000
Date:   Sat, 23 May 2020 02:19:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/24] xfs: clean up the buffer iodone callback functions
Message-ID: <20200523091902.GB28135@infradead.org>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-11-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:15PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we've sorted inode and dquot buffers, we can apply the same
> cleanups to dirty buffers with buffer log items. They only have one

Btw, I find the "dirty" buffers terminology strange, as we don't really
use that anywhere else in xfs_buf.[ch].

The patch itself looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
