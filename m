Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6D28EDE2
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 09:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgJOHsn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 03:48:43 -0400
Received: from verein.lst.de ([213.95.11.211]:59491 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgJOHsn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Oct 2020 03:48:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 43F4F68B05; Thu, 15 Oct 2020 09:48:42 +0200 (CEST)
Date:   Thu, 15 Oct 2020 09:48:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, chandanrlinux@gmail.com, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: annotate grabbing the realtime bitmap/summary
 locks in growfs
Message-ID: <20201015074842.GH14082@lst.de>
References: <160235126125.1384192.1096112127332769120.stgit@magnolia> <160235126770.1384192.7924916439728391885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160235126770.1384192.7924916439728391885.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
