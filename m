Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A889B1C0F08
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 09:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgEAHuR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 03:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgEAHuR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 03:50:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2203BC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 00:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=adSBixYXJWm/9CLpx5jHhISHtJTCOLW7EYmSpl6Bgdw=; b=k2RagnSgyz2PdFP5KKvPOMLgLd
        ZNTQ+IE4pupfdy5CK1KPoSih7Yd+UzmUZZRBVqAWRN8ZeGf7+gP/PmLhTDhHFI4Kn0oOz5hoHFK8u
        X7iMjMRqGASNX7c67gxJhqA433vZgDDBFwBUBmUtUvWmnkTsCR05kercmhU/sx4E8Aph/MVvMqUMw
        3x0ncdxuEx4IR9GOro9VkOINZUtj1zO8dYp9J2KNvBuPp37tNX+eat6aiL/IhKHWpIDbjScypZvlC
        SpmzC8bSWvlTI4GmMYHb+Tye4PU0kn11n182T0i7sOGycYpa38VhbknfuzEQWtgUtdP2G0XAykoQ0
        Ev7c3N1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQR7-0004bX-0T; Fri, 01 May 2020 07:50:17 +0000
Date:   Fri, 1 May 2020 00:50:16 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 10/17] xfs: acquire ->ail_lock from
 xfs_trans_ail_delete()
Message-ID: <20200501075016.GE29479@infradead.org>
References: <20200429172153.41680-1-bfoster@redhat.com>
 <20200429172153.41680-11-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429172153.41680-11-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 29, 2020 at 01:21:46PM -0400, Brian Foster wrote:
> Several callers acquire the lock just prior to the call. Callers
> that require ->ail_lock for other purposes already check IN_AIL
> state and thus don't require the additional shutdown check in the
> helper. Push the lock down into xfs_trans_ail_delete(), open code
> the instances that still acquire it, and remove the unnecessary ailp
> parameter.

Much better calling conventions with your changes,

Reviewed-by: Christoph Hellwig <hch@lst.de>
