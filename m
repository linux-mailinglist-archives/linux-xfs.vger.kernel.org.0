Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB171DAADC
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 08:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgETGnA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 May 2020 02:43:00 -0400
Received: from verein.lst.de ([213.95.11.211]:47955 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETGnA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 May 2020 02:43:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E18F568B02; Wed, 20 May 2020 08:42:58 +0200 (CEST)
Date:   Wed, 20 May 2020 08:42:58 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/11] xfs: fix inode ag walk predicate function return
 values
Message-ID: <20200520064258.GH2742@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993916840.976105.5237746648594071986.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158993916840.976105.5237746648594071986.stgit@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
