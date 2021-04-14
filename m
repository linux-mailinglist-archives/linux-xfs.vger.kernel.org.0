Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B33F35ECC0
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Apr 2021 07:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347993AbhDNF7q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Apr 2021 01:59:46 -0400
Received: from verein.lst.de ([213.95.11.211]:57387 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348396AbhDNF7q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Apr 2021 01:59:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A6FD168AFE; Wed, 14 Apr 2021 07:59:23 +0200 (CEST)
Date:   Wed, 14 Apr 2021 07:59:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove XFS_IFEXTENTS
Message-ID: <20210414055923.GA24575@lst.de>
References: <20210412133819.2618857-1-hch@lst.de> <20210412133819.2618857-8-hch@lst.de> <20210414003744.GU3957620@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414003744.GU3957620@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 05:37:44PM -0700, Darrick J. Wong wrote:
> <shrug> Seeing how we already had a go-round where Dave and stumbled
> over each other about the somewhat duplicative flags and format fields
> I'm inclined to take this sooner or later just to eliminate the
> ambiguity...

Do you want me to resend for the comment that Brian wants to see, or
do you want to just fold that in?
