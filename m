Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB2B17941A
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 16:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgCDPxy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 10:53:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51594 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgCDPxy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:53:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Xd1zyrlGCWN6aUNLAIobEgMOT1ZK6KwmAUxcNlRn4QM=; b=iCGrteP7yQCrxZEGZ5e2xSNnli
        Ak/EKVudOhiPNisiwfTNVPwk1/tnAdv0/W30CfHsan3OXQWM1hWQfaSfRSl3r3UwTVR+QWO2tBeFy
        qZZRvMAcucUrOZxWSL5WYXyOxW6h+ExReQ2GRmtyV4JPkq4P8i71SM/9zq7d7iQbHm+9/b9czgamj
        Z/ptOqcRMxwbLJD98cvVYposGEI7jXhNWDtBtlWRc34RCT3jHzCV0uoNc4cvzErrTQNv7VqvDoCQX
        dcxt7vVaIUyNB4eNdOB/ot+pY1W31MCKhkz1oYqAU88OK3wLn9mmaKNiCCgK9J/oecD1oq63smfGP
        OB96xz9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WLK-0001yv-Af; Wed, 04 Mar 2020 15:53:54 +0000
Date:   Wed, 4 Mar 2020 07:53:54 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/11] xfs: remove some stale comments from the log code
Message-ID: <20200304155354.GH17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-11-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:54:00PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
