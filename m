Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298D6DBE10
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Oct 2019 09:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733243AbfJRHOX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 18 Oct 2019 03:14:23 -0400
Received: from verein.lst.de ([213.95.11.211]:45751 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728008AbfJRHOX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Oct 2019 03:14:23 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id CEC9668BE1; Fri, 18 Oct 2019 09:14:20 +0200 (CEST)
Date:   Fri, 18 Oct 2019 09:14:20 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: enhance writeback error message
Message-ID: <20191018071420.GA23408@lst.de>
References: <20191017210110.GP13108@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017210110.GP13108@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
