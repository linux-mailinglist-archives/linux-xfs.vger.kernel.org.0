Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BEE17941B
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2020 16:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbgCDPyR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Mar 2020 10:54:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbgCDPyQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 10:54:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GZlJHctu7FDaJzylFoWtRgE2OTA9HpQ6Vo7jrqDJny4=; b=hX7yGDG6Kkx5Pz0zFFdEELgQiq
        R0vDjh0Cf+PpUdXrWea4thVIYVjNSUdvoGk14mgVt7e6jCFOH+uz2fPYNkrVCW4zahfWzCjh6CyUi
        1j71J41gg+4cuU7vrzUQ+8LXuOwlXf/CjblYHwzAH4B6Vpu8e2pvDng+4FnWqlHm4IfgNYAfkyq61
        ufefzKGAtuUlax+4bcxR4H31PKQe9dQ+zHO9w/Gx4bGAWf7woG/H8vCuDkQ5iXv2KVSG+tFJQOrqL
        LYOyvzPobg2xpl5cgUCRQHi6Vgl32di43f8c12HaR2OwXrMQnmfzljmgNvrYYowuStQ+rJXFeJcbt
        SFKtzv1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j9WLg-0001zq-E4; Wed, 04 Mar 2020 15:54:16 +0000
Date:   Wed, 4 Mar 2020 07:54:16 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: kill XLOG_TIC_INITED
Message-ID: <20200304155416.GI17565@infradead.org>
References: <20200304075401.21558-1-david@fromorbit.com>
 <20200304075401.21558-12-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304075401.21558-12-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 04, 2020 at 06:54:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> It is not longer used or checked by anything, so remove the last
> traces from the log ticket code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
