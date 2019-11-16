Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02930FF4A2
	for <lists+linux-xfs@lfdr.de>; Sat, 16 Nov 2019 19:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKPSPG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 16 Nov 2019 13:15:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfKPSPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:15:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jlt4CfEoQjiQx19i0L8xlGYKknnmgQJNysRbrCDXLqE=; b=G2o+GlgfZlK/YAV/95bsjNWwA
        yUIChdjcYbrb+umUONwlQE2YwsCDuVDKk4S6Oe/KQbjjhfWgKQfY55y1mfE6wU/Sycj2ula36UwoO
        aRt03kSCDdMZs9tgBfCKHcuR/y5ZDH0rfHJJP5WQ+vs2DHIb95nXyCpyfZpwRz0IPk/Nck0jjifSj
        3g50+gDBZLzibQq/fH4YlaKQyQZOv2N+ynwUruluTfVtCkBqkfIrBm6iuewVN7NNyN9GNPXA8hlcC
        9eNIyZc1hDZY9qTPCghO29Gmm5/W3ZLBj1U6hIPuavmRs31Lo6jtMLsr+2rIdMqR/LpKUd7fQyKSs
        iS3nZYq0Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2bB-0004gF-Li; Sat, 16 Nov 2019 18:15:05 +0000
Date:   Sat, 16 Nov 2019 10:15:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to f368b29ba917
Message-ID: <20191116181505.GA15462@infradead.org>
References: <20191114181654.GG6211@magnolia>
 <20191116070236.GA30357@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116070236.GA30357@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 15, 2019 at 11:02:36PM -0800, Christoph Hellwig wrote:
> FYI, this crash for me in xfs/348 with unfortunately a completely
> garbled dmesg.  The xfs-5.5-merge-11 is fine.

git-bisect points to:

xfs: convert open coded corruption check to use XFS_IS_CORRUPT
