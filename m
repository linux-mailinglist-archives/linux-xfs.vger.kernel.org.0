Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6851918980F
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Mar 2020 10:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgCRJkj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Mar 2020 05:40:39 -0400
Received: from verein.lst.de ([213.95.11.211]:35889 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbgCRJkj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Mar 2020 05:40:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B422168C65; Wed, 18 Mar 2020 10:40:37 +0100 (CET)
Date:   Wed, 18 Mar 2020 10:40:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/14] xfs: refactor xlog_state_clean_iclog
Message-ID: <20200318094037.GC6538@lst.de>
References: <20200316144233.900390-1-hch@lst.de> <20200316144233.900390-7-hch@lst.de> <20200317132505.GG24078@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317132505.GG24078@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 09:25:05AM -0400, Brian Foster wrote:
> The code looks mostly fine, but I'm not a fan of this factoring where we
> deref ->l_covered_state here and return a value only for the caller to
> assign it to ->l_covered_state again. Can we just let this function
> assign ->l_covered_state itself (i.e. assign a local variable rather than
> return within the switch)?

I did that earlier, but this version looked easier to understand to me.
I can change it if there is a strong preference.
