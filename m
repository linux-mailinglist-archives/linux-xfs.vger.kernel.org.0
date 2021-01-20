Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD49F2FD5ED
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Jan 2021 17:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391629AbhATQnv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 Jan 2021 11:43:51 -0500
Received: from verein.lst.de ([213.95.11.211]:56659 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732354AbhATQk7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Jan 2021 11:40:59 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 906D168B02; Wed, 20 Jan 2021 17:40:04 +0100 (CET)
Date:   Wed, 20 Jan 2021 17:40:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, avi@scylladb.com
Subject: Re: [PATCH 10/11] iomap: add a IOMAP_DIO_UNALIGNED flag
Message-ID: <20210120164003.GA21436@lst.de>
References: <20210118193516.2915706-1-hch@lst.de> <20210118193516.2915706-11-hch@lst.de> <20210118214137.GG2260413@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118214137.GG2260413@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I've renamed it to IOMAP_DIO_SUBBLOCK
