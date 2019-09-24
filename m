Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58246BD45C
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2019 23:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732310AbfIXVaU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Sep 2019 17:30:20 -0400
Received: from verein.lst.de ([213.95.11.211]:52803 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfIXVaU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 17:30:20 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4322B68BE1; Tue, 24 Sep 2019 23:30:16 +0200 (CEST)
Date:   Tue, 24 Sep 2019 23:30:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: revert 1baa2800e62d ("xfs: remove the unused
 XFS_ALLOC_USERDATA flag")
Message-ID: <20190924213015.GA31474@lst.de>
References: <20190923235224.GW2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923235224.GW2229799@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
