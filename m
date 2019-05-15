Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5040D1E89B
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 08:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfEOGwk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 02:52:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfEOGwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vz1DNNMsnDeTSYlKtQdP3QOxAAs+jK831Y1WkCm4t3U=; b=s9OkzBJ9w2LU2LPJZ8dWMaqs+
        7Ia3uCByHG3G0f8uq2zF1xWUs/Z0BDCkTU3OilTPxP8gWMFO2oYSgO60eKX0p2dWm6FN4Vud8QoV0
        dhNd4/DYSI3BnlwBaDNmuCWm5+x4pkIz8kCyO8F5f7ZhES7G3Coh3t9lC1jAxqlXkJk4BRaF8dVj1
        s2VzAobPO3Roh3VWlcgHVgp/Izr9oqM/cOSOKcsTYoVksYCpykAYe4Z+Gh6myx/uEiQhLScmeywwn
        xchZVWz5QhkP+bWk6rh1M5lb3nKwcpu4teac9Y2Ap5e7/vlr3wIpoVMN6vnHNRHioGPZ1HgI9wV0N
        CpB3kEJFQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQnmI-00012b-KH; Wed, 15 May 2019 06:52:38 +0000
Date:   Tue, 14 May 2019 23:52:38 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] libxfs: create new file trans_buf.c
Message-ID: <20190515065238.GF29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-7-git-send-email-sandeen@redhat.com>
 <20190515060750.GY29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515060750.GY29573@dread.disaster.area>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 04:07:50PM +1000, Dave Chinner wrote:
> On Fri, May 10, 2019 at 03:18:25PM -0500, Eric Sandeen wrote:
> > Pull functions out of libxfs/*.c into trans_buf.c, if they roughly match
> > the kernel's xfs_trans_buf.c file.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> So I have no problems with this, but I'm not sure what the eventual
> goal is? Just sharing code, or is there some functionality that
> requires a more complete transaction subsystem in userspace?
> 
> I'm asking because if the goal is eventual unification with the
> kernel code, then we probably should name the files the same as the
> kernel code so we don't have to rename them again when we do the
> unification. That will make history searching a bit easier - less
> file names to follow across and git blame works a whole lot better...

Even if we don't want to directly share code having the same file
name would still be nice..
