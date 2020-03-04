Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70369179416
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 16:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgCDPwB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 10:52:01 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51538 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgCDPwB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Wz0Nf8/Ic8ebzHxJwTFmZS03+yqiqblsR0BZ32/Pi9Q=; b=lzuytayd3Ce5ZekD3B3rKA6RLG
        /RSmieYJZ/EUFFoYW/AHGrnMkWIKw0/w+XVj0/xV28bq3sADQkuaP3qiYFS82CEoGL5pAso3Vffre
        twShg5n8SjsKl+Zu8feWmf67UtVw4Zyq8NBpJe5Reiy5IX3Q01AJ7Nr6IdKWAyL5WplMlOy8jmTrB
        /qSzVMi40BwEUY3eEVIrOmEt7TUcB4q08epQWHXutXqEUdCpvazY5yPmNpqHiXfHlSCLE+RV0YbPY
        YNbncPkB2xRVHWmjA5j5gnNDbyqb9gcOGu+mKYKY05g/pEqtXSg6bhKA1lj26ZiTsbX/xmtH87AVy
        FReWBerA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WJV-0001sS-As; Wed, 04 Mar 2020 15:52:01 +0000
Date:   Wed, 4 Mar 2020 07:52:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: rename the log unmount writing functions.
Message-ID: <20200304155201.GF17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:53:58PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The naming and calling conventions are a bit of a mess. Clean it up
> so the call chain looks like:
> 
> 	xfs_log_unmount_write(mp)
> 	  xlog_unmount_write(log)
> 	    xlog_write_unmount_record(log, ticket)
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
