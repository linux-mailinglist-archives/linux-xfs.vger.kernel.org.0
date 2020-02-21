Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBD516824F
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 16:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgBUPt5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 10:49:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbgBUPt5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 10:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kesqpEYqZt+l8smLjhTzg5ddxFrlWN2gK+jo1J4Pjsk=; b=OG6Vt12TZLIHw2DtPT2K98nI6w
        eYV/2Af08yjga9Zt5miPxIkI+IcH0XhcM1uM8kGroJdM1lSSz9FX+OkD+D1uVO1zFRBO0+d/iBEHS
        1+RCYObjS9f2Wwj91ffDTD7ZIwegIqWcyffO/hXenU4JtwzNCY3aZZNAdtWOVhNqgYMAxBvZlPRan
        VnWLfWs6x6pMtvgcvqQSGxTw42DTRmMZ5nvy0RWJRqQNmLY2Dfx9d4+wjAV0M3NFa0Im7XACscX5Q
        relFYlMjaTpu91PonjZ2oLmYM5kIdD0eJHs/WpnuVHVFN2aRYer9LlToXsQsBQU5OvepOoyv87QnI
        5rX2cMAA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5AYu-0002gz-St; Fri, 21 Feb 2020 15:49:56 +0000
Date:   Fri, 21 Feb 2020 07:49:56 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: improve error message when we can't allocate memory
 for xfs_buf
Message-ID: <20200221154956.GA9866@infradead.org>
References: <20200221154132.GQ9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221154132.GQ9506@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 21, 2020 at 07:41:32AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If xfs_buf_get_map can't allocate enough memory for the buffer it's
> trying to create, it'll cough up an error about not being able to
> allocate "pagesn".  That's not particularly helpful (and if we're really
> out of memory the message is very spammy) so change the message to tell
> us how many pages were actually requested, and ratelimit it too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
