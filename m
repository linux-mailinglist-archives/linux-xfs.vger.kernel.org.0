Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9ED3D9849
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Jul 2021 00:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhG1WTg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Jul 2021 18:19:36 -0400
Received: from sandeen.net ([63.231.237.45]:58632 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhG1WTg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 18:19:36 -0400
Received: from liberator.local (204-195-4-157.wavecable.com [204.195.4.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id CE2011F0D;
        Wed, 28 Jul 2021 17:18:10 -0500 (CDT)
Subject: Re: [PATCH 1/1] xfs_io: allow callers to dump fs stats individually
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <162750699314.45983.15238050911081991698.stgit@magnolia>
 <162750699859.45983.16505496110971663895.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <729e5e98-f0c9-eaf7-8478-9ad9674817af@sandeen.net>
Date:   Wed, 28 Jul 2021 15:19:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <162750699859.45983.16505496110971663895.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/28/21 2:16 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Enable callers to decide if they want to see statfs, fscounts, or
> geometry information (or any combination) from the xfs_io statfs
> command.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks functional this time :P
(and thanks for tidying up the other bits like the default behavior etc)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

