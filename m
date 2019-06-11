Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A393C659
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 10:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404599AbfFKIqy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 04:46:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404584AbfFKIqx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 04:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cNT8SfWaLkXjgqmsFDWvaOVNESNX+QbYAKxk0xhI0W0=; b=n1b0oFfHVEu6jBHxnX4OfV9rC
        005648tg5kxnPJqnDPlCqe4TgSU/HgiKUTXmqn0ueBKJ1algMuduGWUdpN/ijDNPfoPPGYymZAMRY
        OqcfYnd7I7sH5G42Y8kFug3ARqpQdEmCQ+ON2O3wV48wD1t8HxD8g7hxBhvcEQWfH7uO3Kr4Sc27i
        5Z56VOXWoT9kpXn9AlyIiyiNX4B6bJXiu8ZIAw4DogxaiQ2apJSg5hiH8ZLr5i7XXDgUUDJwTn/Ik
        zejoNCGHfKIdwxNLwkfySY3l7TRGDpYsCZQsn7XnvrYBvj5Cvk370eOVzuZdtk4mxm3AKPqY1ANPL
        uriTMZHxg==;
Received: from [213.208.157.36] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hacQb-0003W8-Kf; Tue, 11 Jun 2019 08:46:50 +0000
Date:   Tue, 11 Jun 2019 10:46:46 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
Message-ID: <20190611084646.GA22981@infradead.org>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-3-hch@lst.de>
 <20190520220844.GD5335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520220844.GD5335@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 20, 2019 at 03:08:44PM -0700, Darrick J. Wong wrote:
> > -xlog_state_do_callback(
> > -	struct xlog		*log,
> > -	int			aborted,
> > -	struct xlog_in_core	*iclog);
> > +STATIC void xlog_state_done_syncing(
> > +	struct xlog_in_core	*iclog,
> > +	bool			aborted);
> 
> I totally mistook this for a function definition. :/
> 
> STATIC void xlog_state_done_syncing(struct xlog_in_core *iclog, bool aborted);
> 
> ...seems to fit on one line, right?

Yes, but this style is used by all the forward declarations in
xfs_log.c.  Eventually we should fix them all, or even better get rid
of most of them.
