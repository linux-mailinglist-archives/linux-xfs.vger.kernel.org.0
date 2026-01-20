Return-Path: <linux-xfs+bounces-29926-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GLQ4NyVqcGkVXwAAu9opvQ
	(envelope-from <linux-xfs+bounces-29926-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:54:45 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9B151C09
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 113467065D8
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jan 2026 14:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9A4436363;
	Tue, 20 Jan 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gEOAGw+3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBCA1EFF9B;
	Tue, 20 Jan 2026 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768920458; cv=none; b=US2Cf7GmX4bV/39CanwE4R3Q4EqvUTceKnMdgvSGfKI0PsNnBbpm4w1f8tYbxF+Iyw9HTe0VFIE8itZUD3gBYIzqjbVk/29u/pFVnLlb0OWrNNcn5YKVDDoL5mCpfKEFg/RedvwEwa+rEjf9lyH7pcE22HY5g6jXbs+NRuNg+g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768920458; c=relaxed/simple;
	bh=OTPVc43NSkyIQGFcfIWoDfj2FBqKztTB/OGgKXzTYOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwhTD3Wwv2kqbx+55dExRUy/D9HYRzB508p9/s29FkEFXzJNgPsxkuoCotVH99P4QV1qemSurvocLP9OAlp4sJ7fy4/nnLd/P8nkOGKtX+b3YkdVCqlsN5hCq7pDwutUjf0eY2LA3EWNSMvY3kpHZ6Npw1KFxuq+qopx2wYDUrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gEOAGw+3; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768920457; x=1800456457;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OTPVc43NSkyIQGFcfIWoDfj2FBqKztTB/OGgKXzTYOU=;
  b=gEOAGw+30LXCicg5SFYl6rsmPaICZLHb7/EcILDj8wx5tHaqI1iv+dbU
   d6SK1m4m1mdPyYz9Xg1iyPQ1lPfcJVaXBQhYPMLfEPzP8BOFI/9qzOuN6
   WCAaUGf8YfhkBvUfHHel/++fv53nMD6wcvKiFeJe8pjteaZm0kT1PoyQN
   hTHeFpreVZRQr9zNDZssHb2YZnNRSjbdGRQb4VM6VHmtekiTv+HPTD0qQ
   yViEOqqFWCmSLfwiwmytnIeaMr5NVrE5Cq2V5kur7RkCpzJ38f4wWHN5L
   YSLaEqgjD7nrcF1TcwgeKCZ2pBd8Xe4MJfscHAVx3csWq19G+Ax9AJdZX
   w==;
X-CSE-ConnectionGUID: XKQD/LJCScehlu0xKiUrRQ==
X-CSE-MsgGUID: 28o5dFrkSYyt0Eumz3Fi9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81570502"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81570502"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:47:37 -0800
X-CSE-ConnectionGUID: Hh+MTS57QZ6ux+wrDw1A5w==
X-CSE-MsgGUID: I8scmMxeSKGUuTtWlnGWcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="205389130"
Received: from dhhellew-desk2.ger.corp.intel.com (HELO localhost) ([10.245.244.240])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 06:47:34 -0800
Date: Tue, 20 Jan 2026 16:47:32 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 2/3] lib: fix a few comments to match kernel-doc
 -Wreturn style
Message-ID: <aW-VhE6usl7Mc63G@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
 <20260120141229.356513-1-dmantipov@yandex.ru>
 <20260120141229.356513-2-dmantipov@yandex.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120141229.356513-2-dmantipov@yandex.ru>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-29926-lists,linux-xfs=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	FREEMAIL_TO(0.00)[yandex.ru];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andriy.shevchenko@intel.com,linux-xfs@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[smile.fi.intel.com:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: 7F9B151C09
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 05:12:28PM +0300, Dmitry Antipov wrote:
> Fix 'get_option()', 'memparse()' and 'parse_option_str()' comments
> to match the commonly used style as suggested by kernel-doc -Wreturn.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Thanks for doing this change, I think it should go first for the consistency's
sake.

-- 
With Best Regards,
Andy Shevchenko



